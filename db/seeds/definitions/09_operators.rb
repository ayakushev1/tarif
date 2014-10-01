def access_methods_to_constant_countries  
#2 operators
  _russian_operators = 3001; _foreign_operators = 3002
  _tele_2 = 1023; _beeline = 1025; _megafon = 1028; _mts = 1030; 
  _mts_ukrain = 1031; _kiev_star = 1027; 
  _fixed_line_operator = 1034; _other_rusian_operator = 1035
  _operators = [_beeline, _megafon, _mts]
  
  _russian_operators_group = [_tele_2, _beeline, _megafon, _mts, _other_rusian_operator, _fixed_line_operator]
  _sic_operators_group = [_mts_ukrain, _kiev_star]
  _other_operators_group = []
  
#3 operator's groups
  _bln_partner_operators = [_beeline, _kiev_star]


  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_countries

