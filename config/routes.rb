Router.define do
  root to: Pages::Home
  match "404", to: Pages::NotFound
  match "500", to: Pages::ServiceError
  match "test", to: Pages::Nested::Test
end
