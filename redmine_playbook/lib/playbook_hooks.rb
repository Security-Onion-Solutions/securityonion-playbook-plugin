class PlaybookHooks  < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = {})
        stylesheet_link_tag('playbook', :plugin => :redmine_playbook)
    end

    render_on :view_layouts_base_body_bottom, :partial => 'playbook/footer'

end
