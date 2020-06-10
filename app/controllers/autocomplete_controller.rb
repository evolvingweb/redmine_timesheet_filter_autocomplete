class AutocompleteController < ApplicationController
    def autocomplete
        data = [
            {
                id: "project_=_1",
                label: "My Project"
            }
        ]
        respond_to do |format|
            format.html {
              render json: data, status: 200, layout: nil
            }
        end
    end
end
