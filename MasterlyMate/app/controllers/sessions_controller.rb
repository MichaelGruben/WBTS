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

# This controller handles the session of all authorized users.
# The sessions will be persist in a session-file.
# After a session, the information about the session will be removed from this session-file.
# The actions from this controller are not going to render anything back to the requestor.
# All actions from this controller are handled as background processes.
class SessionsController < ApplicationController
  
  # This action is only initiating the create action
  def new
  end
  
  # If the guest user is trying to authenticate against a user account, this
  # action will then check the authentification of the requestor.
  # If authentication was successful, the requestor will be redirected to the start page.
  # Otherwise the requestor will get a hint, that the account informations were not correct.
  def create
    @user = User.find_by_username_none_case_sensitive(params[:username])
    if @user and @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "#{t('login.successful')}, #{@user.username}"
    else
      flash[:error] = t("login.failed")
      redirect_to "#{root_path}?failed=1"
    end 
  end
  
  # A session of a specified user will be destroyed, if the
  # user is logging out from his account.
  # After the user has logged out from his account, he will be
  # redirected to the start page.
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t("logout.successful")
  end
  
end
