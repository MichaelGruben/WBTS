#########################################################################
#Copyright 2013 Michael Gruben, Julian Babics, Benjamin Merkle
#
#This file is part of Masterly Mate.
#
#Masterly Mate is free software: you can redistribute it and/or modify it
#under the terms of the GNU Affero General Public License as published by
#the Free Software Foundation, either version 3 of the License, or (at
#your option) any later version.
#
#Masterly Mate is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU Affero General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License
#along with Masterly Mate.  If not, see <http://www.gnu.org/licenses/>.
#
#Diese Datei ist Teil von Masterly Mate.
#
#Masterly Mate ist Freie Software: Sie können es unter den Bedingungen
#der GNU Affero General Public License, wie von der Free Software
#Foundation, Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren
#veröffentlichten Version, weiterverbreiten und/oder modifizieren.
#
#Masterly Mate wird in der Hoffnung, dass es nützlich sein wird, aber
#OHNE JEDE GEWÄHELEISTUNG, bereitgestellt; sogar ohne die implizite
#Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN
#ZWECK.
#Siehe die GNU Affero General Public License für weitere Details.
#
#Sie sollten eine Kopie der GNU Affero General Public License zusammen
#mit Masterly Mate erhalten haben. Wenn nicht, siehe
#<http://www.gnu.org/licenses/>.
#########################################################################

MasterlyMate::Application.routes.draw do
    
  scope "(:locale)", :locale => /en|de/ do
    resources :users do
      resources :assessments
    end
    resources :ranks
    resources :groups
    resources :topics
    resources :wbts
  end
  
  # routes without locale
  match "/users/:id/updateExam" => "users#updateExam"
  match "/administrator" => "backend#index", as: "admin"
  match "/" => "frontend#index", as: "root"
  
  # routes  with locale
  match "/:locale/users/:id/initProgressbars" => "users#initProgressbars"
  match "/:locale/users/:id/updateExam" => "users#updateExam"
  match "/:locale/users/:id/assessments" => "assessments#index", as: "user_assessments_path"
  match "/:locale/users/:id/assessments/:id" => "assessments#show", as: "user_assessment_path"
  match "/:locale/administrator" => "backend#index", as: "admin"
  match "/:locale/users" => "users#index"
  match "/:locale/login" => "sessions#new", as: "login"
  match "/:locale/sessions" => "sessions#create", as: "sessions"
  match "/:locale/logout" => "sessions#destroy", as: "logout"
  match "/:locale/wbts/:id" => "wbts#start"
  match "/:locale/upload/:file/:mainFile" => redirect("/upload/%{file}/%{mainFile}")
  match "/:locale/topics" => "topics#index"
  match "/:locale/users/:id/statistic/" => "users#statistic", as: "users_statistic"
  match "/:locale/" => "frontend#index", as: "root"
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
