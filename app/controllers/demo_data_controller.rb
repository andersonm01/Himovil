class DemoDataController < ApplicationController
  def create
    DemoData.load!
    redirect_to root_path, notice: "Datos de ejemplo cargados."
  end

  def destroy
    DemoData.clear!
    redirect_to root_path, notice: "Datos de ejemplo eliminados.", status: :see_other
  end
end
