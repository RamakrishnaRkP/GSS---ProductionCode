tableextension 60115 GSSCustomer extends Customer
{
    fields
    {
        field(50001; "Credit Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Credit End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Insurance Ref no"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "Insurance Credit Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60100; "GSSCreatedBy User"; Code[50])
        {
            Caption = 'Created By User';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
        field(60110; "GSSTeam"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Team';
            TableRelation = Team.Code;
            Editable = false;
        }
        field(60120; "GSSCredit Insurance Limit(LCY)"; Decimal)
        {
            Caption = 'Credit Insurance Limit (LCY)';
            DataClassification = CustomerContent;
            //AccessByPermission = tabledata "G/L Register" = R;
        }
        field(60121; "GSS Dispute"; Boolean)
        {
            Caption = 'Dispute';
            DataClassification = CustomerContent;
        }
        modify("Salesperson Code")
        {
            trigger OnAfterValidate()
            var
                SalespersonTeams: record "Team Salesperson";
            begin
                TestStatusOpen();
                SalespersonTeams.SetCurrentKey("Team Code", "Salesperson Code");
                SalespersonTeams.SetRange("Salesperson Code", "Salesperson Code");
                if SalespersonTeams.FindFirst() then
                    Validate("GSSTeam", SalespersonTeams."Team Code")
                else
                    Validate(GSSTeam, '');
            end;
        }

        ///Rk 221026
        field(60122; "Old Credit Limit"; Decimal)
        {
            Caption = 'Old Credit Limit';
            DataClassification = CustomerContent;
            //Editable = false;
        }

        field(60123; "Credit Limit Difference"; Decimal)
        {
            Caption = 'Credit Limit Difference';
            DataClassification = CustomerContent;
            //Editable = false;
        }
        field(60124; "Reason for Credit Change"; Text[250])
        {
            Caption = 'Reason for Credit Change';
            DataClassification = CustomerContent;
        }
        field(60125; "Previous Credit Limit"; Decimal)
        {
            Caption = 'Previous Credit Limit';
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeInsert()
    begin
        // ValidateMandatoryCustomerFields();
    end;

    trigger OnBeforeModify()
    begin
        //  ValidateMandatoryCustomerFields();
    end;

    local procedure ValidateMandatoryCustomerFields()
    begin
        // 1. Customer Name
        if Rec.Name = '' then
            Error('Customer Name is mandatory. Please enter the Customer Name before saving.');
        // 2. Address
        if Rec.Address = '' then
            Error('Address is mandatory. Please enter the Customer Address before saving.');
        // 3. Contact Person
        if Rec.Contact = '' then
            Error('Contact Person is mandatory. Please enter the Contact Person before saving.');
        // 4. Contact Number
        if Rec."Phone No." = '' then
            Error('Contact Number is mandatory. Please enter the Contact Number before saving.');
        // 5. Email ID
        if Rec."E-Mail" = '' then
            Error('Email ID is mandatory. Please enter the Email ID before saving.');
        // 6. Payment Terms
        if Rec."Payment Terms Code" = '' then
            Error('Payment Terms is mandatory. Please select the Payment Terms before saving.');
        // 7. Country/Region
        if Rec."Country/Region Code" = '' then
            Error('Country/Region is mandatory. Please select the Country/Region before saving.');
        // 8. Credit Limit (must be greater than zero)
        // if Rec."Credit Limit (LCY)" <= 0 then
        //  Error('Credit Limit is mandatory. Please enter a Credit Limit greater than 0 before saving.');
    end;
}
