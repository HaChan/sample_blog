namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_entries
    make_relationships
    make_comments
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_entries
  users = User.all(limit: 6)
  50.times do
    title = Faker::Lorem.sentence(1)
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.entries.create!(title: title, content: content) }
  end
end

def make_comments
  i=Entry.first.id
  5.times do
    entry = Entry.find(i)
    i = i-1
    50.times do
      content = Faker::Lorem.sentence(5)
      entry.comments.create!(content: content, user_id: 1 + Random.rand(20))
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
