TarifList.delete_all
tlst =[]

TarifList.transaction do
  TarifList.create(tlst)
end
