class ServiceHelper::Services
  
  def self.tarifs
    {
      1025 => [],
      1028 => [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 112, 113],
      1030 => [200, 201, 202, 203, 204, 205, 206, 207, 208, 210, 212],
    }
  end  

  def self.common_services
    {
      1025 => [],
      1028 => [174, 177, 178, 179],
      1030 => [276, 277, 312],
    }
  end  

  def self.tarif_options
    {
      1025 => tarif_options_by_type[1025].map{|t| t[1]}.flatten,
      1028 => tarif_options_by_type[1028].map{|t| t[1]}.flatten,
      1030 => tarif_options_by_type[1030].map{|t| t[1]}.flatten,
    }
  end  

  def self.tarif_options_by_type
    {
      1025 => {
        :international_rouming => [],
        :country_rouming => [],  
        :mms => [],  
        :sms => [],  
        :calls => [],  
        :internet => [],  
      },
      1028 => {
        :international_rouming => [
          400, 401, 402, 403, 404, 405, 406, 407, #calls
          410, 411, 412, 413, #sms
          430, 431, 432, #internet
          ],
        :country_rouming => [440, 441, 442, 443, 444, 445],  
        :mms => [450, 451, 452],  
        :sms => [455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466],  
        :calls => [470, 471, 472, 473],  
        :internet => [475, 476, 477, 478, 479, 480, 481, 482, 484, 485, 486, 487],  
      },
      1030 => {
        :international_rouming => [288, 289, 290, 291, 292],
        :country_rouming => [294, 282, 283, 297, 321, 322],  
        :mms => [323, 324, 325, 326],  
        :sms => [295, 296, 305, 306, 307, 308, 333, 334, 335, 336, 337, 338, 339],  
        :calls => [328, 329, 330, 331, 332, 281, 309, 293, 280],  
        :internet => [302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342],  
      },
    }
  end  

end

