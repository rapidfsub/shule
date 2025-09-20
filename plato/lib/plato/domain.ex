defmodule Plato.Domain do
  use Ash.Domain,
    extensions: [AshPhoenix]

  resources do
    resource Plato.Campus do
      define(:create_campus, action: :create)
      define(:list_campuses, action: :read)
      define(:get_campus, action: :read, get_by: [:id])
      define(:update_campus, action: :update)
      define(:destroy_campus, action: :destroy)
    end

    resource Plato.Student do
      define(:create_student, action: :create)
      define(:list_students, action: :read)
      define(:get_student, action: :read, get_by: [:id])
      define(:update_student, action: :update)
      define(:destroy_student, action: :destroy)
    end

    resource Plato.Problem do
      define(:create_problem, action: :create)
      define(:list_problems, action: :read)
      define(:get_problem, action: :read, get_by: [:id])
      define(:update_problem, action: :update)
      define(:destroy_problem, action: :destroy)
    end

    resource Plato.Instructor do
      define(:create_instructor, action: :create)
      define(:list_instructors, action: :read)
      define(:get_instructor, action: :read, get_by: [:id])
      define(:update_instructor, action: :update)
      define(:destroy_instructor, action: :destroy)
    end
  end
end
