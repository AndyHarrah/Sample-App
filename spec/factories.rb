
Factory.define :user do |user|
  user.name										"Foo Bar"
	user.email									"foo@example.com"
	user.password								"foobar"
	user.password_confirmation	"foobar"
end

