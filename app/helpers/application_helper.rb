module ApplicationHelper
  def main_menu_button_for(name, text, number = nil, additional = nil)
    content_tag :div, nil, class: 'main-menu-button' do
      content_tag :div, nil, class: 'col-lg-6 col-lg-offset-3 col-md-8 col-md-offset-2 col-sm-8 col-sm-offset-2 col-xs-10 col-xs-offset-1' do
        # concat content_tag :span, nil, class: "hidden-xs icon icon-#{name}"
        icon = content_tag :div, nil do
          concat image_tag name + '.png', class: 'hidden-xs'
          concat text
        end

        if number.present?
          output = content_tag :span, number.to_s, class: 'text-right'
          output += content_tag :span, "#{additional[0]}/#{additional[1]}", class: 'small'  if additional.present?
          counter = content_tag :div, output, class: "counter#{red_counter ||= ''}"
        end

        icon + counter
      end
    end
end
end
