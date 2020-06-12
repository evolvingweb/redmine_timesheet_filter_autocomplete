# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'timesheet/filter/autocomplete/:search', :to => 'autocomplete#autocomplete'