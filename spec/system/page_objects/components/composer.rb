# frozen_string_literal: true

module PageObjects
  module Components
    class Composer < PageObjects::Components::Base
      COMPOSER_ID = "#reply-control"
      AUTOCOMPLETE_MENU = ".autocomplete.ac-emoji"

      def opened?
        page.has_css?("#{COMPOSER_ID}.open")
      end

      def open_composer_actions
        find(".composer-action-title .btn").click
        self
      end

      def click_toolbar_button(button_class)
        find(".d-editor-button-bar button.#{button_class}").click
        self
      end

      def fill_title(title)
        find("#{COMPOSER_ID} #reply-title").fill_in(with: title)
        self
      end

      def fill_content(content)
        composer_input.fill_in(with: content)
        self
      end

      def fill_form_template_field(field, content)
        form_template_field(field).fill_in(with: content)
        self
      end

      def type_content(content)
        composer_input.send_keys(content)
        self
      end

      def clear_content
        fill_content("")
      end

      def has_content?(content)
        composer_input.value == content
      end

      def has_popup_content?(content)
        composer_popup.has_content?(content)
      end

      def select_action(action)
        find(action(action)).click
        self
      end

      def create
        find("#{COMPOSER_ID} .btn-primary").click
      end

      def action(action_title)
        ".composer-action-title .select-kit-collection li[title='#{action_title}']"
      end

      def button_label
        find("#{COMPOSER_ID} .btn-primary .d-button-label")
      end

      def emoji_picker
        find("#{COMPOSER_ID} .emoji-picker")
      end

      def emoji_autocomplete
        find(AUTOCOMPLETE_MENU)
      end

      def category_chooser
        Components::SelectKit.new(".category-chooser")
      end

      def switch_category(category_name)
        find(".category-chooser").click
        find(".category-row[data-name='#{category_name}']").click
      end

      def preview
        find("#{COMPOSER_ID} .d-editor-preview-wrapper")
      end

      def has_emoji_autocomplete?
        has_css?(AUTOCOMPLETE_MENU)
      end

      def has_no_emoji_autocomplete?
        has_no_css?(AUTOCOMPLETE_MENU)
      end

      EMOJI_SUGGESTION_SELECTOR = "#{AUTOCOMPLETE_MENU} .emoji-shortname"

      def has_emoji_suggestion?(emoji)
        has_css?(EMOJI_SUGGESTION_SELECTOR, text: emoji)
      end

      def has_no_emoji_suggestion?(emoji)
        has_no_css?(EMOJI_SUGGESTION_SELECTOR, text: emoji)
      end

      def has_emoji_preview?(emoji)
        page.has_css?(emoji_preview_selector(emoji))
      end

      def has_no_emoji_preview?(emoji)
        page.has_no_css?(emoji_preview_selector(emoji))
      end

      COMPOSER_INPUT_SELECTOR = "#{COMPOSER_ID} .d-editor-input"

      def has_no_composer_input?
        page.has_no_css?(COMPOSER_INPUT_SELECTOR)
      end

      def has_composer_input?
        page.has_css?(COMPOSER_INPUT_SELECTOR)
      end

      def has_composer_preview?
        page.has_css?("#{COMPOSER_ID} .d-editor-preview-wrapper")
      end

      def has_no_composer_preview?
        page.has_no_css?("#{COMPOSER_ID} .d-editor-preview-wrapper")
      end

      def has_composer_preview_toggle?
        page.has_css?("#{COMPOSER_ID} .toggle-preview")
      end

      def has_no_composer_preview_toggle?
        page.has_no_css?("#{COMPOSER_ID} .toggle-preview")
      end

      def has_form_template?
        page.has_css?(".form-template-form__wrapper")
      end

      def has_form_template_field?(field)
        page.has_css?(".form-template-field[data-field-type='#{field}']")
      end

      def has_form_template_field_required_indicator?(field)
        page.has_css?(
          ".form-template-field[data-field-type='#{field}'] .form-template-field__required-indicator",
        )
      end

      FORM_TEMPLATE_CHOOSER_SELECTOR = ".composer-select-form-template"

      def has_no_form_template_chooser?
        page.has_no_css?(FORM_TEMPLATE_CHOOSER_SELECTOR)
      end

      def has_form_template_chooser?
        page.has_css?(FORM_TEMPLATE_CHOOSER_SELECTOR)
      end

      def has_form_template_field_error?(error)
        page.has_css?(".form-template-field__error", text: error)
      end

      def composer_input
        find("#{COMPOSER_ID} .d-editor .d-editor-input")
      end

      def composer_popup
        find("#{COMPOSER_ID} .composer-popup")
      end

      def form_template_field(field)
        find(".form-template-field[data-field-type='#{field}']")
      end

      def move_cursor_after(text)
        execute_script(<<~JS, text)
          const text = arguments[0];
          const composer = document.querySelector("#{COMPOSER_ID} .d-editor-input");
          const index = composer.value.indexOf(text);
          const position = index + text.length;

          composer.setSelectionRange(position, position);
        JS
      end

      def select_all
        execute_script(<<~JS, text)
          const composer = document.querySelector("#{COMPOSER_ID} .d-editor-input");
          composer.setSelectionRange(0, composer.value.length);
        JS
      end

      def close
        find("#{COMPOSER_ID} .save-or-cancel .cancel").click
      end

      private

      def emoji_preview_selector(emoji)
        ".d-editor-preview .emoji[title=':#{emoji}:']"
      end
    end
  end
end
