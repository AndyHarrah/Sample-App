
Factory.define :user do |user|
  user.name										"Example User"
	user.email									"foo@example.com"
	user.password								"foobar"
	user.password_confirmation	"foobar"
end

