get   'projects/:id/sigma_editor',         :to => 'sigma_editor#edit'
get   'projects/:id/sigma_editor/example', :to => 'sigma_editor#example'
get   'projects/:id/sigma_editor/example2', :to => 'sigma_editor#example2'
match 'projects/:id/sigma_editor/convert', :to => 'sigma_editor#convert', :via => [ :post, :put ]
match 'projects/:id/sigma_editor/create',  :to => 'sigma_editor#create',  :via => [ :post, :put ]
