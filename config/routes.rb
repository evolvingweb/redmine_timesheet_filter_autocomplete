# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'timesheet/filter/autocomplete', :to => 'autocomplete#autocomplete'

get 'timesheet/filter/:identifier/autocomplete', :to => 'autocomplete#autocomplete'