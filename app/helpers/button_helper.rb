module ButtonHelper

  def back_button_class
    ' button small secondary'
  end

  def save_button_class
    ' button small'
  end

  def edit_button_class
    ' button small'
  end

  def show_button_class
    ' button small'
  end

  def download_button_class
    ' button small success'
  end

  def cancel_button_class
    ' button small alert'
  end

  def delete_button(*args)
    text = 'Delete'
    default_options = { method: :delete, class: cancel_button_class }
    common_named_button_helper(text, default_options, *args)
  end

  def back_button(*args)
    text = "Back"
    common_named_button_helper(text, {}, *args)
  end

  def show_button(*args)
    text = "Show"
    default_options = { class: show_button_class }
    common_named_button_helper(text, default_options, *args)
  end

  def edit_button(*args)
    text = "Edit"
    default_options = { class: edit_button_class }
    common_named_button_helper(text, default_options, *args)
  end

  def download_button(*args)
    text = "Download"
    common_named_button_helper(text, {}, *args)
  end

  private

  def common_named_button_helper(text, default_options, *args)
    default_options = {
      class: ' button small secondary'
    }.merge(default_options)

    args = args.unshift(text)

    if !args.last.is_a?(Hash)
      args << {}
    end
    options_hash = args.last
    options_hash = default_options.merge(options_hash)

    args[args.length - 1] = options_hash

    link_to(*args)
  end

end
