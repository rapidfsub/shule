defmodule Shou.Domain do
  use Ash.Domain

  resources do
    resource Shou.Domain.Obj do
      define :create_obj, action: :create
      define :list_objs, action: :read
      define :list_objs_by_name, action: :read_by_name, args: [:name]
    end
  end
end
