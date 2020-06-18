module TimesheetFilterAutocomplete
    class JSHooks < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        p = context[:request].params
        if p[:controller] == "timelog" && (p[:action] == "report" || p[:action] == "index")
          js_files = %w{redmine-timesheet-filter-autocomplete.js}
          js_files.map do |file|
            javascript_include_tag(file, :plugin=> 'redmine_timesheet_filter_autocomplete')
          end
        end
      end
    end
    class CSSHooks < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        p = context[:request].params
        if p[:controller] == "timelog" && (p[:action] == "report" || p[:action] == "index")
          css_files = %w{redmine-timesheet-filter-autocomplete.css}
          css_files.map do |file|
            stylesheet_link_tag(file, :plugin=> 'redmine_timesheet_filter_autocomplete')
          end
        end
      end
    end
  end
  