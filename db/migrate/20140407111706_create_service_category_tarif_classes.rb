class CreateServiceCategoryTarifClasses < ActiveRecord::Migration
  def change
    create_table :service_category_tarif_classes do |t|
      t.references :tarif_class
      t.references :service_category_rouming
      t.references :service_category_geo
      t.references :service_category_partner_type
      t.references :service_category_calls
      t.references :service_category_one_time
      t.references :service_category_periodic
      t.references :as_standard_category_group
      t.references :as_tarif_class_service_category
      t.integer :tarif_class_service_categories, array: true, default:[]
      t.integer :standard_category_groups, array: true, default:[]
      t.boolean :is_active, index: true
      
      t.timestamps      
    end
    add_index :service_category_tarif_classes, :tarif_class_id, name: 'service_category_tarif_classes_tarif_class_id'
    add_index :service_category_tarif_classes, :service_category_rouming_id, name: 'service_category_tarif_classes_service_category_rouming_id'
    add_index :service_category_tarif_classes, :service_category_geo_id, name: 'service_category_tarif_classes_service_category_geo_id'
    add_index :service_category_tarif_classes, :service_category_partner_type_id, name: 'service_category_tarif_classes_service_category_partner_type_id'
    add_index :service_category_tarif_classes, :service_category_calls_id, name: 'service_category_tarif_classes_service_category_calls_id'
    add_index :service_category_tarif_classes, :service_category_one_time_id, name: 'service_category_tarif_classes_service_category_one_time_id'
    add_index :service_category_tarif_classes, :service_category_periodic_id, name: 'service_category_tarif_classes_service_category_periodic_id'
    add_index :service_category_tarif_classes, :as_standard_category_group_id, name: 'service_category_tarif_classes_as_standard_category_group_id'
    add_index :service_category_tarif_classes, :as_tarif_class_service_category_id, name: 'service_category_tarif_classes_as_tarif_class_service_category'
    add_index :service_category_tarif_classes, :tarif_class_service_categories, name: 'service_category_tarif_classes_tarif_class_service_categories', using: 'gin'
    add_index :service_category_tarif_classes, :standard_category_groups, name: 'service_category_tarif_classes_standard_category_groups', using: 'gin'
  end
end

