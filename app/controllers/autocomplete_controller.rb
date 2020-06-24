class AutocompleteController < ApplicationController
    def autocomplete()
        data = []
        data = data + users_search(params)
        if !params.key?(:identifier)
            data = data + projects_search(params[:term])
        end
        data = data + dates_search(params[:term])

        respond_to do |format|
            format.html {
              render json: data, status: 200, layout: nil
            }
        end
    end

    def users_search(params)
        search = params[:term]
        data = []
        project_id = 3
        users = User.where("login LIKE :search OR firstname LIKE :search OR lastname LIKE :search OR CONCAT(firstname, ' ', lastname  ) LIKE :search", {search: "%#{search}%"})
        if params.key?(:identifier)
            project = Project.find_by(identifier: params[:identifier])
            if project
                project_id = project.id
                # Filter by only project members.
                users = users.joins("INNER JOIN members on members.user_id = users.id").where("members.project_id = :project_id", {project_id: project_id})
            end
        end
        users.each do |user|
            data << {
                id: "user_id/=/#{user.id}",
                label: "#{user.firstname} #{user.lastname} (User)"
            }
        end
        data
    end

    def projects_search(search)
        data = []
        projects = Project.where("status <> 9 AND (name LIKE :search OR description LIKE :search OR identifier LIKE :search)", {search: "%#{search}%"})
        projects.each do |project|
            data << {
                id: "project_id/=/#{project.id}",
                label: "#{project.name} (Project)"
            }
        end
        data
    end

    def dates_search(search)
        data = []
        available_dates = []
        available_dates.append({
            :id => "today",
            :operator => "t",
            :value => "",
            :label => "Today"
        })

        available_dates.append({
            :id => "yesterday",
            :operator => "ld",
            :value => "",
            :label => "Yesterday"
        })

        available_dates.append({
            :id => "this week",
            :operator => "w",
            :value => "",
            :label => "This week"
        })

        available_dates.append({
            :id => "last week",
            :operator => "lw",
            :value => "",
            :label => "Last week"
        })

        available_dates.append({
            :id => "last 2 weeks",
            :operator => "l2w",
            :value => "",
            :label => "Last 2 weeks"
        })

        available_dates.append({
            :id => "this month",
            :operator => "m",
            :value => "",
            :label => "This month"
        })

        available_dates.append({
            :id => "last month",
            :operator => "lm",
            :value => "",
            :label => "Last month"
        })

        available_dates.append({
            :id => "this year",
            :operator => "y",
            :value => "",
            :label => "This year"
        })

        for available_date in available_dates
            if available_date[:id].downcase.include?(search.downcase)
                data << {
                    id: "spent_on/#{available_date[:operator]}/#{available_date[:value]}",
                    label: available_date[:label]
                }
            end
        end
        data
    end
end
