require 'test_helper'

class ContractValidateTest < MiniTest::Spec
  Song  = Struct.new(:title, :album, :composer)
  Album = Struct.new(:name, :songs, :artist)
  Artist = Struct.new(:name)

  class AlbumForm < Reform::Contract
    property :name
    validation do
      key(:name).required
    end

    collection :songs do
      property :title
      validation do
        key(:title).required
      end

      property :composer do
        validation do
          key(:name).required
        end
        property :name
      end
    end

    property :artist do
      property :name
    end
  end

  let (:song)               { Song.new("Broken") }
  let (:song_with_composer) { Song.new("Resist Stance", nil, composer) }
  let (:composer)           { Artist.new("Greg Graffin") }
  let (:artist)             { Artist.new("Bad Religion") }
  let (:album)              { Album.new("The Dissent Of Man", [song, song_with_composer], artist) }

  let (:form) { AlbumForm.new(album) }

  # valid
  it do
    form.validate.must_equal true
    form.errors.messages.inspect.must_equal "{}"
  end

  # invalid
  it do
    album.songs[1].composer.name = nil
    album.name = nil

    form.validate.must_equal false
    form.errors.messages.inspect.must_equal "{:name=>[\"is missing\"], :\"songs.composer.name\"=>[\"is missing\"]}"
  end
end


# no configuration results in "sync" (formerly known as parse_strategy: :sync).
class ValidateWithoutConfigurationTest < MiniTest::Spec
  Song  = Struct.new(:title, :album, :composer)
  Album = Struct.new(:name, :songs, :artist)
  Artist = Struct.new(:name)

  class AlbumForm < Reform::Form
    property :name
    validation do
      key(:name).required
    end

    collection :songs do

      property :title
      validation do
        key(:title).required
      end

      property :composer do
        property :name
        validation do
          key(:name).required
        end
      end
    end

    property :artist do
      property :name
    end
  end

  let (:song)               { Song.new("Broken") }
  let (:song_with_composer) { Song.new("Resist Stance", nil, composer) }
  let (:composer)           { Artist.new("Greg Graffin") }
  let (:artist)             { Artist.new("Bad Religion") }
  let (:album)              { Album.new("The Dissent Of Man", [song, song_with_composer], artist) }

  let (:form) { AlbumForm.new(album) }

  # valid.
  it do
    object_ids = {song: form.songs[0].object_id, song_with_composer: form.songs[1].object_id,
      artist: form.artist.object_id, composer: form.songs[1].composer.object_id}

    form.validate(
      "name"   => "Best Of",
      "songs"  => [{"title" => "Fallout"}, {"title" => "Roxanne", "composer" => {"name" => "Sting"}}],
      "artist" => {"name" => "The Police"},
    ).must_equal true

    form.errors.messages.inspect.must_equal "{}"

    # form has updated.
    form.name.must_equal "Best Of"
    form.songs[0].title.must_equal "Fallout"
    form.songs[1].title.must_equal "Roxanne"
    form.songs[1].composer.name.must_equal "Sting"
    form.artist.name.must_equal "The Police"

    # objects are still the same.
    form.songs[0].object_id.must_equal object_ids[:song]
    form.songs[1].object_id.must_equal object_ids[:song_with_composer]
    form.songs[1].composer.object_id.must_equal object_ids[:composer]
    form.artist.object_id.must_equal object_ids[:artist]


    # model has not changed, yet.
    album.name.must_equal "The Dissent Of Man"
    album.songs[0].title.must_equal "Broken"
    album.songs[1].title.must_equal "Resist Stance"
    album.songs[1].composer.name.must_equal "Greg Graffin"
    album.artist.name.must_equal "Bad Religion"
  end

  # with symbols.
  it do
    form.validate(
      name:   "Best Of",
      songs:  [{title: "The X-Creep"}, {title: "Trudging", composer: {name: "SNFU"}}],
      artist: {name: "The Police"},
    ).must_equal true

    form.name.must_equal "Best Of"
    form.songs[0].title.must_equal "The X-Creep"
    form.songs[1].title.must_equal "Trudging"
    form.songs[1].composer.name.must_equal "SNFU"
    form.artist.name.must_equal "The Police"
  end

  # throws exception when no populators.
  it do
    album = Album.new("The Dissent Of Man", [])

    assert_raises RuntimeError do
      AlbumForm.new(album).validate(songs: {title: "Resist-Stance"})
    end
  end
end

class ValidateWithInternalPopulatorOptionTest < MiniTest::Spec
  Song  = Struct.new(:title, :album, :composer)
  Album = Struct.new(:name, :songs, :artist)
  Artist = Struct.new(:name)

  class AlbumForm < Reform::Form
    property :name
    validation do
      key(:name).required
    end

    collection :songs,
      internal_populator: lambda { |input, options|
              collection = options[:represented].songs
              (item = collection[options[:index]]) ? item : collection.insert(options[:index], Song.new) } do

      property :title
      validation do
        key(:title).required
      end

      property :composer, internal_populator: lambda { |input, options| (item = options[:represented].composer) ? item : Artist.new } do
        property :name
        validation do
          key(:name).required
        end
      end
    end

    property :artist, internal_populator: lambda { |input, options| (item = options[:represented].artist) ? item : Artist.new } do
      property :name
      validation do
        key(:name).required
      end
    end
  end

  let (:song)               { Song.new("Broken") }
  let (:song_with_composer) { Song.new("Resist Stance", nil, composer) }
  let (:composer)           { Artist.new("Greg Graffin") }
  let (:artist)             { Artist.new("Bad Religion") }
  let (:album)              { Album.new("The Dissent Of Man", [song, song_with_composer], artist) }

  let (:form) { AlbumForm.new(album) }

  # valid.
  it("xxx") do
    form.validate(
      "name"   => "Best Of",
      "songs"  => [{"title" => "Fallout"}, {"title" => "Roxanne", "composer" => {"name" => "Sting"}}],
      "artist" => {"name" => "The Police"},
    ).must_equal true

    form.errors.messages.inspect.must_equal "{}"

    # form has updated.
    form.name.must_equal "Best Of"
    form.songs[0].title.must_equal "Fallout"
    form.songs[1].title.must_equal "Roxanne"
    form.songs[1].composer.name.must_equal "Sting"
    form.artist.name.must_equal "The Police"


    # model has not changed, yet.
    album.name.must_equal "The Dissent Of Man"
    album.songs[0].title.must_equal "Broken"
    album.songs[1].title.must_equal "Resist Stance"
    album.songs[1].composer.name.must_equal "Greg Graffin"
    album.artist.name.must_equal "Bad Religion"
  end

  # invalid.
  it do
    form.validate(
      "name"   => "",
      "songs"  => [{"title" => "Fallout"}, {"title" => "Roxanne", "composer" => {"name" => ""}}],
      "artist" => {"name" => ""},
    ).must_equal false

    form.errors.messages.inspect.must_equal "{:name=>[\"must be filled\"], :\"songs.composer.name\"=>[\"must be filled\"], :\"artist.name\"=>[\"must be filled\"]}"
  end

  # adding to collection via :instance.
  # valid.
  it do
    form.validate(
      "songs"  => [{"title" => "Fallout"}, {"title" => "Roxanne"}, {"title" => "Rime Of The Ancient Mariner"}],
    ).must_equal true

    form.errors.messages.inspect.must_equal "{}"

    # form has updated.
    form.name.must_equal "The Dissent Of Man"
    form.songs[0].title.must_equal "Fallout"
    form.songs[1].title.must_equal "Roxanne"
    form.songs[1].composer.name.must_equal "Greg Graffin"
    form.songs[1].title.must_equal "Roxanne"
    form.songs[2].title.must_equal "Rime Of The Ancient Mariner" # new song added.
    form.songs.size.must_equal 3
    form.artist.name.must_equal "Bad Religion"


    # model has not changed, yet.
    album.name.must_equal "The Dissent Of Man"
    album.songs[0].title.must_equal "Broken"
    album.songs[1].title.must_equal "Resist Stance"
    album.songs[1].composer.name.must_equal "Greg Graffin"
    album.songs.size.must_equal 2
    album.artist.name.must_equal "Bad Religion"
  end


  # allow writeable: false even in the deserializer.
  class SongForm < Reform::Form
    property :title, deserializer: {writeable: false}
  end

  it do
    form = SongForm.new(song = Song.new)
    form.validate("title" => "Ignore me!")
    form.title.must_equal nil
    form.title = "Unopened"
    form.sync # only the deserializer is marked as not-writeable.
    song.title.must_equal "Unopened"
  end
end

#   # not sure if we should catch that in Reform or rather do that in disposable. this is https://github.com/apotonick/reform/pull/104
#   # describe ":populator with :empty" do
#   #   let (:form) {
#   #     Class.new(Reform::Form) do
#   #       collection :songs, :empty => true, :populator => lambda { |fragment, index, args|
#   #         songs[index] = args.binding[:form].new(Song.new)
#   #       } do
#   #         property :title
#   #       end
#   #     end
#   #    }

#   #   let (:params) {
#   #     {
#   #       "songs" => [{"title" => "Fallout"}, {"title" => "Roxanne"}]
#   #     }
#   #   }

#   #   subject { form.new(Album.new("Hits", [], [])) }

#   #   before { subject.validate(params) }

#   #   it { subject.songs[0].title.must_equal "Fallout" }
#   #   it { subject.songs[1].title.must_equal "Roxanne" }
#   # end


#   # test cardinalities.
#   describe "with empty collection and cardinality" do
#     let (:album) { Album.new }

#     subject { Class.new(Reform::Form) do
#       include Reform::Form::ActiveModel
#       model :album

#       collection :songs do
#         property :title
#       end

#       property :hit do
#         property :title
#       end

#       validates :songs, :length => {:minimum => 1}
#       validates :hit, :presence => true
#     end.new(album) }


#     describe "invalid" do
#       before { subject.validate({}).must_equal false }

#       it do
#         # ensure that only hit and songs keys are present
#         subject.errors.messages.keys.sort.must_equal([:hit, :songs])
#         # validate content of hit and songs keys
#         subject.errors.messages[:hit].must_equal(["must be filled"])
#         subject.errors.messages[:songs].first.must_match(/\Ais too short \(minimum is 1 characters?\)\z/)
#       end
#     end


#     describe "valid" do
#       let (:album) { Album.new(nil, Song.new, [Song.new("Urban Myth")]) }

#       before {
#         subject.validate({"songs" => [{"title"=>"Daddy, Brother, Lover, Little Boy"}], "hit" => {"title"=>"The Horse"}}).
#           must_equal true
#       }

#       it { subject.errors.messages.must_equal({}) }
#     end
#   end





#   # providing manual validator method allows accessing form's API.
#   describe "with ::validate" do
#     let (:form) {
#       Class.new(Reform::Form) do
#         property :title

#         validate :title?

#         def title?
#           errors.add :title, "not lowercase" if title == "Fallout"
#         end
#       end
#      }

#     let (:params) { {"title" => "Fallout"} }
#     let (:song) { Song.new("Englishman") }

#     subject { form.new(song) }

#     before { @res = subject.validate(params) }

#     it { @res.must_equal false }
#     it { subject.errors.messages.must_equal({:title=>["not lowercase"]}) }
#   end


#   # overriding the reader for a nested form should only be considered when rendering.
#   describe "with overridden reader for nested form" do
#     let (:form) {
#       Class.new(Reform::Form) do
#         property :band, :populate_if_empty => lambda { |*| Band.new } do
#           property :label
#         end

#         collection :songs, :populate_if_empty => lambda { |*| Song.new } do
#           property :title
#         end

#         def band
#           raise "only call me when rendering the form!"
#         end

#         def songs
#           raise "only call me when rendering the form!"
#         end
#       end.new(album)
#      }

#      let (:album) { Album.new }

#      # don't use #artist when validating!
#      it do
#        form.validate("band" => {"label" => "Hellcat"}, "songs" => [{"title" => "Stand Your Ground"}, {"title" => "Otherside"}])
#        form.sync
#        album.band.label.must_equal "Hellcat"
#        album.songs.first.title.must_equal "Stand Your Ground"
#      end
#   end
# end
