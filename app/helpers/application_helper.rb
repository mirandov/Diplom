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
  # Генерирует кнопку "Назад"
 def back_btn_to(path, id=nil, data=nil)
   link_to t('views.buttons.back'), path, class: 'btn btn-default', id: id, data: data
 end

 def full_path
    request.env['ORIGINAL_FULLPATH']
 end
 
 # Генерирует кнопку "Далее"
 def next_btn_to(form, options = {class: 'btn btn-primary'})
   form.button :submit, t('views.buttons.next'), options
 end

 # Генерирует кнопку "Редактировать"
 def edit_btn_to(path, text=nil)
   if text.nil?
     text = t 'views.buttons.edit'
   end
   text = (text.to_s if text.present?)
   classes = 'btn btn-primary'
   link_to(
       path,
       class: classes,
       title: text) do
     content_tag(:span, nil, class: ('glyphicon glyphicon-pencil' unless text)) +
         "\n#{text}"
   end
 end

 # Генерирует кнопку "Удалить"
 def delete_btn_to(path, text=nil)
   if text.nil?
     text = t 'views.buttons.delete'
   end
   text = (text.to_s if text.present?)
   classes = 'btn btn-primary'
   link_to(
       path,
       method: :delete,
       class: classes,
       data: { confirm: t('views.messages.are_you_sure') },
       title: text) do
     content_tag(:span, nil, class: ('glyphicon glyphicon-trash' unless text)) +
         "\n#{text}"
   end
 end

 def back_to_list_btn(path)
   link_to path, class: 'btn btn-default btn-sm' do
     content_tag(:span, nil, class: 'glyphicon glyphicon-list-alt').concat(
         " #{t('views.buttons.to_list')}"
     )
   end
 end

 def pick_btn_to(path, params)
   link_to(path, class: 'btn btn-success', title: t('views.buttons.pick'))
 end

 def download_btn_to(path)
   link_to(path, class: 'btn btn-primary btn-sm', target: '_blank',
           :title => t('views.buttons.download')) do
     content_tag :span, nil, :class => 'glyphicon glyphicon-download'
   end
 end

 def page_header
    path = Rails.application.routes.recognize_path(request.env['PATH_INFO'])
    t "controllers.#{path[:controller]}.#{path[:action]}"
  end

end
