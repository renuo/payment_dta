require 'payments/base'
class ESRPayment < DTA::Payments::Base
 include Comparable
 
 def <=>(other)
   if  requested_processing_date == other.requested_processing_date
     if issuer_identification == other.issuer_identification
       return ordering_party_bank_clearing_number <=> other.ordering_party_bank_clearing_number
     else
       return issuer_identification <=> other.issuer_identification
     end
   else
     return requested_processing_date <=> other.requested_processing_date
   end
 end
 
 def transaction_type
   '826'
 end
 
 def payment_type
   '0'
 end
 
 def beneficiarys_esr_party_number
  "/C/#{@data[:beneficiarys_esr_party_number].to_s.rjust(9,'0')}"
 end
 
 def beneficiary_address
  beneficiary_address_line1 + beneficiary_address_line2 + beneficiary_address_line3 + beneficiary_address_line4
 end
 
 def beneficiary_address_line1
   @data[:beneficiary_address_line1].to_s.ljust(20)
 end

 def beneficiary_address_line2
   @data[:beneficiary_address_line2].to_s.ljust(20)
 end

 def beneficiary_address_line3
   @data[:beneficiary_address_line3].to_s.ljust(20)
 end

 def beneficiary_address_line4
   @data[:beneficiary_address_line4].to_s.ljust(20)
 end
 
 def reason_for_payment_esr_reference_number
  if @data[:beneficiarys_esr_party_number].to_s.size == 5
    @data[:reason_for_payment_esr_reference_number].to_s.ljust(27)
  else
    @data[:reason_for_payment_esr_reference_number].to_s.rjust(27,'0')
  end
 end
 
 def beneficiarys_esr_party_number_check
  @data[:beneficiarys_esr_party_number_check].to_s.ljust(2)
 end
 
 protected
 
 def build_segment1
  super + reference_number + account_to_be_debited + payment_amount + reserve_field(14)
 end
 
 def build_segment2
   super + ordering_partys_address + reserve_field(46)
 end
 
 def build_segment3
   super + beneficiarys_esr_party_number + beneficiary_address + reason_for_payment_esr_reference_number + beneficiarys_esr_party_number_check + reserve_field(5)
 end 
end