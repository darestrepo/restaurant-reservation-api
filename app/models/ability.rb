# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user # Store user for use in methods
    return if user.nil? || user.role.nil?

    # Call the appropriate method based on user role
    case user.role
    when 'admin', 0
      admin_abilities
    when 'restaurant', 1
      restaurant_abilities
    when 'guest', 2
      guest_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def restaurant_abilities
    return unless @user.restaurant_id.present?

    # Restaurant users can manage their own restaurant data
    can :read, Restaurant, id: @user.restaurant_id
    
    # Can manage reservations for their restaurant
    can :manage, Reservation, restaurant_id: @user.restaurant_id
    
    # Can manage guests for their restaurant
    can :manage, Guest, restaurant_id: @user.restaurant_id
    
    # Can manage tables for their restaurant
    can :manage, Table, restaurant_id: @user.restaurant_id
    
    # Can manage sections for their restaurant
    can :manage, Section, restaurant_id: @user.restaurant_id
    
    # Can manage their own user account
    can :manage, User, id: @user.id
  end

  def guest_abilities
    return unless @user.restaurant_id.present?
    
    # Guest users can only read their restaurant data
    can :read, Restaurant, id: @user.restaurant_id
    
    # Can read reservations for their restaurant
    can :read, Reservation, restaurant_id: @user.restaurant_id
    
    # Can only manage their own reservations
    can :manage, Reservation, user_id: @user.id
    
    # Can only read guests for their restaurant
    can :read, Guest, restaurant_id: @user.restaurant_id
    
    # Can read tables for their restaurant
    can :read, Table, restaurant_id: @user.restaurant_id
    
    # Can read sections for their restaurant
    can :read, Section, restaurant_id: @user.restaurant_id
    
    # Can manage their own user account
    can :manage, User, id: @user.id
  end
end
