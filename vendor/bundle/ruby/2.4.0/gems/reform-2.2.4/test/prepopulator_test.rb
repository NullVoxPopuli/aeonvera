require 'test_helper'

class PrepopulatorTest < MiniTest::Spec
  Song = Struct.new(:title, :band, :length)
  Band = Struct.new(:name)

  class AlbumForm < Reform::Form
    property :title, prepopulator: ->(*){ self.title = "Another Day At Work" }                  # normal assignment.
    property :length

    property :hit, prepopulator: ->(options) { self.hit = Song.new(options[:title]) } do # use user options.
      property :title

      property :band, prepopulator: ->(options){ self.band = my_band(options[:title]) } do                             # invoke your own code.
        property :name
      end

      def my_band(name)
        Band.new(title)
      end
    end

    collection :songs, prepopulator: :prepopulate_songs! do
        property :title
    end

  private
    def prepopulate_songs!(options)
      if songs == nil
        self.songs = [Song.new, Song.new]
      else
        songs << Song.new # full Twin::Collection API available.
      end
    end
  end

  it do
    form = AlbumForm.new(OpenStruct.new(length: 1)).prepopulate!(title: "Potemkin City Limits")

    form.length.must_equal 1
    form.title.must_equal "Another Day At Work"
    form.hit.model.must_equal Song.new("Potemkin City Limits")
    form.songs.size.must_equal 2
    form.songs[0].model.must_equal Song.new
    form.songs[1].model.must_equal Song.new
    form.songs[1].model.must_equal Song.new
    # prepopulate works more than 1 level, recursive.
    # it also passes options properly down there.
    form.hit.band.model.must_equal Band.new("Potemkin City Limits")
  end

  # add to existing collection.
  it do
    form = AlbumForm.new(OpenStruct.new(songs: [Song.new])).prepopulate!

    form.songs.size.must_equal 2
    form.songs[0].model.must_equal Song.new
    form.songs[1].model.must_equal Song.new
  end
end

# calling form.prepopulate! shouldn't crash.
class PrepopulateWithoutConfiguration < MiniTest::Spec
  Song = Struct.new(:title)

  class AlbumForm < Reform::Form
    collection :songs do
      property :title
    end

    property :hit do
      property :title
    end
  end

  subject { AlbumForm.new(OpenStruct.new(songs: [], hit: nil)).prepopulate! }

  it { subject.songs.size.must_equal 0 }
end


class ManualPrepopulatorOverridingTest < MiniTest::Spec
  Song = Struct.new(:title, :band, :length)
  Band = Struct.new(:name)

  class AlbumForm < Reform::Form
    property :title
    property :length

    property :hit do
      property :title

      property :band do
        property :name
      end
    end

    def prepopulate!(options)
      self.hit = Song.new(options[:title])
      super
    end
  end

  # you can simply override Form#prepopulate!
  it do
    form = AlbumForm.new(OpenStruct.new(length: 1)).prepopulate!(title: "Potemkin City Limits")

    form.length.must_equal 1
    form.hit.model.must_equal Song.new("Potemkin City Limits")
    form.hit.title.must_equal "Potemkin City Limits"
  end
end