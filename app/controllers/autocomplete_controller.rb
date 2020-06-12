class AutocompleteController < ApplicationController
    def autocomplete()
        data = []
        users = User.where("login LIKE :search OR firstname LIKE :search OR lastname LIKE :search OR CONCAT(firstname, ' ', lastname  ) LIKE :search", {search: "%#{params[:search]}%"})
        users.each do |user|
            data << {
                id: "User_#{user.id}",
                label: "#{user.firstname} #{user.lastname}"
            }
        end
        respond_to do |format|
            format.html {
              render json: data, status: 200, layout: nil
            }
        end
    end
end
