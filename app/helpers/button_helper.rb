module ButtonHelper


  def back_button(*args)
    text = "Back"
    common_named_button_helper(text, *args)
  end

  def show_button(*args)
    text = "Show"
    common_named_button_helper(text, *args)
  end

  def edit_button(*args)
    text = "Edit"
    common_named_button_helper(text, *args)
  end

  def download_button(*args)
    text = "Download"
    common_named_button_helper(text, *args)
  end

  private

  def common_named_button_helper(text, *args)
    args = args.unshift(text)

    if !args.last.is_a?(Hash)
      args << {}
    end
    options_hash = args.last
    options_hash[:class] ||= ""

    options_hash[:class] << " button small secondary "
    args[args.length - 1] = options_hash

    link_to(*args)
  end

end
