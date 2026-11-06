tableextension 60136 "Vendor Mandatory Fields Ext" extends Vendor
{
    fields
    {
    }
    trigger OnBeforeInsert()
    begin
    //  ValidateMandatoryVendorFields();
    end;
    trigger OnBeforeModify()
    begin
    //   ValidateMandatoryVendorFields();
    end;
    local procedure ValidateMandatoryVendorFields()
    begin
        // 1. Vendor Name
        if Rec.Name = '' then Error('Vendor Name is mandatory. Please enter the Vendor Name before saving.');
        // 2. Vendor Address
        if Rec.Address = '' then Error('Vendor Address is mandatory. Please enter the Vendor Address before saving.');
        // 3. Vendor Contact
        if Rec.Contact = '' then Error('Vendor Contact is mandatory. Please enter the Vendor Contact before saving.');
        // 4. Vendor Email Address
        if Rec."E-Mail" = '' then Error('Vendor Email Address is mandatory. Please enter the Vendor Email Address before saving.');
        // 5. Vendor Contact Number
        if Rec."Phone No." = '' then Error('Vendor Contact Number is mandatory. Please enter the Vendor Contact Number before saving.');
        // 6. Vendor TRN Number (VAT Registration No.)
        if Rec."VAT Registration No." = '' then Error('Vendor TRN Number is mandatory. Please enter the VAT Registration No. (TRN) before saving.');
        // 7. Payment Terms
        if Rec."Payment Terms Code" = '' then Error('Payment Terms is mandatory. Please select the Payment Terms before saving.');
        // 8. Country/Region
        if Rec."Country/Region Code" = '' then Error('Country/Region is mandatory. Please select the Country/Region before saving.');
    end;
}
