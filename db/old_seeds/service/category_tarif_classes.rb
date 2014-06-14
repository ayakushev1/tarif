Service::CategoryTarifClass.delete_all; 
ctc = []; 

_tarif_classes.each do |operator, privacy_type|
  privacy_type.each do |privacy, tarif_class_type|
    tarif_class_type[:tarif].each do |tarif_class_id|
      next if _correct_tarif_class_ids.include?(tarif_class_id)
      _stand_cat[:local][:one_time].each do |cat_id|
        ctc << {:id => (cat_id*1000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_one_time_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:local][:periodic].each do |cat_id|
        ctc << {:id => (cat_id*2000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_periodic_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:local][:service_type][:one_side][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*3000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:local][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:local][:service_type][:two_side_in][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*4000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:local][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:local][:service_type][:two_side_out][:stan_serv].each do |stan_cat_id|
        _stand_cat[:local][:service_type][:two_side_out][:geo].each do |geo_cat_id|
          _stand_cat[:local][:service_type][:two_side_out][:partner_type].each do |partner_type_id|
            as_tarif_class_service_category_id = if geo_cat_id == _service_to_home_region
              (((partner_type_id*10 + _service_to_own_region)*30 + stan_cat_id)*5000 + tarif_class_id)
            else
              nil
            end
            ctc << {:id => (((partner_type_id*10 + geo_cat_id)*30 + stan_cat_id)*5000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
              :as_tarif_class_service_category_id => as_tarif_class_service_category_id,
              :service_category_rouming_id => _stand_cat[:local][:rouming_id], :service_category_geo_id => geo_cat_id,
              :service_category_calls_id => stan_cat_id, :service_category_partner_type_id => partner_type_id, :is_active => true} 
          end      
        end      
      end      

      _stand_cat[:home_region][:service_type][:one_side][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*6000 + tarif_class_id), :tarif_class_id => tarif_class_id, :as_tarif_class_service_category_id => (stan_cat_id*3000 + tarif_class_id),
          :service_category_rouming_id => _stand_cat[:home_region][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:home_region][:service_type][:two_side_in][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*7000 + tarif_class_id), :tarif_class_id => tarif_class_id, :as_tarif_class_service_category_id => (stan_cat_id*4000 + tarif_class_id),
          :service_category_rouming_id => _stand_cat[:home_region][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:home_region][:service_type][:two_side_out][:stan_serv].each do |stan_cat_id|
        _stand_cat[:home_region][:service_type][:two_side_out][:geo].each do |geo_cat_id|
          _stand_cat[:home_region][:service_type][:two_side_out][:partner_type].each do |partner_type_id|
            ctc << {:id => (((partner_type_id*10 + geo_cat_id)*30 + stan_cat_id)*8000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
              :as_tarif_class_service_category_id => (((partner_type_id*10 + geo_cat_id)*30 + stan_cat_id)*5000 + tarif_class_id),
              :service_category_rouming_id => _stand_cat[:home_region][:rouming_id], :service_category_geo_id => geo_cat_id,
              :service_category_calls_id => stan_cat_id, :service_category_partner_type_id => partner_type_id, :is_active => true} 
          end      
        end      
      end      
    end

    tarif_class_type[:country_rouming].each do |tarif_class_id|
      next if _correct_tarif_class_ids.include?(tarif_class_id)
      _stand_cat[:home_country][:one_time].each do |cat_id|
        ctc << {:id => (cat_id*9000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_one_time_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:periodic].each do |cat_id|
        ctc << {:id => (cat_id*10000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_periodic_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:service_type][:one_side][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*11000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:home_country][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:service_type][:two_side_in][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*12000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:home_country][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:service_type][:two_side_out][:stan_serv].each do |stan_cat_id|
        _stand_cat[:local][:service_type][:two_side_out][:geo].each do |geo_cat_id|
          _stand_cat[:local][:service_type][:two_side_out][:partner_type].each do |partner_type_id|
            ctc << {:id => (((partner_type_id*10 + geo_cat_id)*30 + stan_cat_id)*13000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
              :service_category_rouming_id => _stand_cat[:home_country][:rouming_id], :service_category_geo_id => geo_cat_id,
              :service_category_calls_id => stan_cat_id, :service_category_partner_type_id => partner_type_id, :is_active => true} 
          end      
        end      
      end      
    end

    tarif_class_type[:world_rouming].each do |tarif_class_id|
      next if _correct_tarif_class_ids.include?(tarif_class_id)
      _stand_cat[:world][:one_time].each do |cat_id|
        ctc << {:id => (cat_id*14000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_one_time_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:world][:periodic].each do |cat_id|
        ctc << {:id => (cat_id*15000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_periodic_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:world][:service_type][:one_side][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*16000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:world][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:world][:service_type][:two_side_in][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*17000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:world][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:world][:service_type][:two_side_out][:stan_serv].each do |stan_cat_id|
        _stand_cat[:local][:service_type][:two_side_out][:geo].each do |geo_cat_id|
          _stand_cat[:local][:service_type][:two_side_out][:partner_type].each do |partner_type_id|
            ctc << {:id => (((partner_type_id*10 + geo_cat_id)*30 + stan_cat_id)*18000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
              :service_category_rouming_id => _stand_cat[:world][:rouming_id], :service_category_geo_id => geo_cat_id,
              :service_category_calls_id => stan_cat_id, :service_category_partner_type_id => partner_type_id, :is_active => true} 
          end      
        end      
      end      
    end

    tarif_class_type[:services].each do |tarif_class_id|
      next if _correct_tarif_class_ids.include?(tarif_class_id)
      _stand_cat[:home_country][:one_time].each do |cat_id|
        ctc << {:id => (cat_id*19000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_one_time_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:periodic].each do |cat_id|
        ctc << {:id => (cat_id*20000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_periodic_id => cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:service_type][:one_side][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*21000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:home_country][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:service_type][:two_side_in][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*22000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => _stand_cat[:home_country][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      _stand_cat[:home_country][:service_type][:two_side_out][:stan_serv].each do |stan_cat_id|
        _stand_cat[:local][:service_type][:two_side_out][:geo].each do |geo_cat_id|
          _stand_cat[:local][:service_type][:two_side_out][:partner_type].each do |partner_type_id|
            ctc << {:id => (((partner_type_id*10 + geo_cat_id)*30 + stan_cat_id)*23000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
              :service_category_rouming_id => _stand_cat[:home_country][:rouming_id], :service_category_geo_id => geo_cat_id,
              :service_category_calls_id => stan_cat_id, :service_category_partner_type_id => partner_type_id, :is_active => true} 
          end      
        end      
      end      
    end if tarif_class_type[:services]
  end
end

#Service::CategoryTarifClass.transaction { Service::CategoryTarifClass.create(ctc) }

@_last_service_category_tarif_class_id = Service::CategoryTarifClass.maximum(:id)
