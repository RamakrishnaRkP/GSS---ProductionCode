pageextension 60172 "Vendor Card Mandatory Ext" extends "Vendor Card"
{
    layout
    {
        // ----- Vendor Name -----
        modify(Name)
        {
            ShowMandatory = true;
        }
        // ----- Vendor Address -----
        modify(Address)
        {
            ShowMandatory = true;
        }
        // ----- Vendor Email Address -----
        modify("E-Mail")
        {
            ShowMandatory = true;
        }
        // ----- Vendor Contact Number -----
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        // ----- Vendor TRN Number (VAT Registration No.) -----
        modify("VAT Registration No.")
        {
            ShowMandatory = true;
        }
        // ----- Payment Terms -----
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
        }
        // ----- Country/Region -----
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify(ATOSBlocked)
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                "Vendor Block Check": Codeunit "Vendor Block Check";
            begin
                if Rec.ATOSBlocked = Rec.ATOSBlocked::" " then exit;
                "Vendor Block Check".CheckPurchaseHeaders(Rec."No.");
                "Vendor Block Check".CheckPurchaseLines(Rec."No.");
                "Vendor Block Check".CheckGenJournalLines(Rec."No.");
                "Vendor Block Check".CheckRequisitionLines(Rec."No.");
                "Vendor Block Check".CheckBankRecLines(Rec."No.");
                "Vendor Block Check".CheckProjectPlanningLines(Rec."No.");
            end;
        }
    }
    // --------------------------------------------------------
    // Page-level validation (runs when user navigates away 
    // from the page, providing an early UI warning before the
    // table-level OnBeforeInsert/OnBeforeModify fires).
    // --------------------------------------------------------
    trigger OnQueryClosePage(CloseAction: Action): Boolean var
        Vendor: Record Vendor;
    begin
        if CloseAction in[ACTION::OK, ACTION::LookupOK]then begin
            Vendor:=Rec;
            if Vendor.Name = '' then begin
                Message('Warning: Vendor Name is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor.Address = '' then begin
                Message('Warning: Vendor Address is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor.Contact = '' then begin
                Message('Warning: Vendor Contact is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor."E-Mail" = '' then begin
                Message('Warning: Vendor Email Address is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor."Phone No." = '' then begin
                Message('Warning: Vendor Contact Number is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor."VAT Registration No." = '' then begin
                Message('Warning: Vendor TRN Number (VAT Registration No.) is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor."Payment Terms Code" = '' then begin
                Message('Warning: Payment Terms is mandatory and has not been filled in.');
                exit(false);
            end;
            if Vendor."Country/Region Code" = '' then begin
                Message('Warning: Country/Region is mandatory and has not been filled in.');
                exit(false);
            end;
        end;
        exit(true);
    end;
}
