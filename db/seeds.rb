
# RECREATE USERS AND ACCOUNTS
User.destroy_all()
Account.destroy_all()
users = {
    'addison@example.com': '12345678'
}

user.each do |user|
    user = User.create!(email: 'addison@example.com', password: '12345678')
    Account.create!(user_id: user.id)
end


# CREATE INITIAL GROUPS FOR ALL USERS
