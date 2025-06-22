class DefaultsGenerator < Rails::Generators::NamedBase
  desc "This generator generates files for default methods to any entity"
  def create_default_tools
    create_file "app/controllers/api/v1/#{plural_name}_controller.rb", <<~RUBY
      module API
        module V1
          class #{plural_name.camelcase}Controller < ApplicationController
            def show
              handler = ::#{plural_name.camelcase}::Handlers::Show.new(self)
              handler.handle!
            end

            def search
              handler = ::#{plural_name.camelcase}::Handlers::Search.new(self)
              handler.handle!
            end

            def create
              handler = ::#{plural_name.camelcase}::Handlers::Create.new(self)
              handler.handle!
            end

            def update
              handler = ::#{plural_name.camelcase}::Handlers::Update.new(self)
              handler.handle!
            end

            def destroy
              handler = ::#{plural_name.camelcase}::Handlers::Destroy.new(self)
              handler.handle!
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/presenters/show.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Presenters
          class Show < ApplicationPresenter
            attr_reader :#{file_name}

            def initialize(#{file_name})
              @#{file_name} = #{file_name}
            end

            def as_json(options = {})
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/presenters/index.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Presenters
          class Index < ApplicationPresenter
            attr_reader :#{plural_name}

            def initialize(#{plural_name})
              @#{plural_name} = #{plural_name}
            end

            def as_json(options = {})
              {
                params: options.fetch(:params, {}),
                #{plural_name}: #{plural_name}.map do |#{file_name}|
                  #{plural_name.camelcase}::Presenters::Show.new(#{file_name}).as_json(options)
                end
              }
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/handlers/create.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Handlers
          class Create < ApplicationHandler
            params do
            end

            payload do
            end

            def handle
              authorize!

              render status: 200 do
                json { #{plural_name.camelcase}::Presenters::Show.new().as_json }
              end
            end

            private def authorize!
              authenticate!
          
              access_denied!
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/handlers/update.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Handlers
          class Update < ApplicationHandler
            params do
            end

            payload do
            end

            def handle
              authorize!

              render status: 200 do
                json { #{plural_name.camelcase}::Presenters::Show.new().as_json }
              end
            end

            private def authorize!
              authenticate!
          
              access_denied!
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/handlers/destroy.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Handlers
          class Destroy < ApplicationHandler
            params do
            end

            payload do
            end

            def handle
              authorize!

              render status: 200 do
                json {}
              end
            end

            private def authorize!
              authenticate!
          
              access_denied!
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/handlers/search.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Handlers
          class Search < ApplicationHandler
            params do
            end

            def handle
              authorize!

              render status: 200 do
                json { #{plural_name.camelcase}::Presenters::Index.new().as_json(params: params) }
              end
            end

            private def authorize!
              authenticate!
          
              access_denied!
            end
          end
        end
      end
    RUBY

    create_file "app/#{plural_name}/handlers/show.rb", <<~RUBY
      module #{plural_name.camelcase}
        module Handlers
          class Show < ApplicationHandler
            params do
            end

            def handle
              authorize!

              render status: 200 do
                json { #{plural_name.camelcase}::Presenters::Show.new().as_json }
              end
            end

            private def authorize!
              authenticate!
          
              access_denied!
            end
          end
        end
      end
    RUBY
  end
end
