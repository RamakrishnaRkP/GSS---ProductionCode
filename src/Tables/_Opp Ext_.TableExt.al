tableextension 60181 "Opp Ext" extends Opportunity
{
    fields
    {
        field(50000; "Customer Type";Enum GSSOpportunityCustomerType)
        {
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
        }
        field(50001; "Email Triggered"; Boolean)
        {
            Caption = 'Email Triggered';
            DataClassification = CustomerContent;
        }
        field(50002; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1), Blocked=CONST(false));
        }
        field(50003; "Pre-Sale Required"; Boolean)
        {
            Caption = 'Pre-Sale Required';
            DataClassification = CustomerContent;
        }
        field(50004; "Pre-Sales Person"; Code[20])
        {
            Caption = 'Pre-SalesPerson';
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
        }
        field(50005; "Pre-SalesPerson Name"; Text[30])
        {
            Caption = 'Pre-SalesPerson Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No."=field("Pre-Sales Person")));
        }
        modify("Contact No.")
        {
        trigger OnBeforeValidate()
        begin
            // Rec.TestField("Salesperson Code");
            if Rec."Customer Type" = Rec."Customer Type"::" " then Error('Customer Type should not be blank');
        end;
        }
    }
    keys
    {
    }
    trigger OnBeforeDelete()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId)then begin
            if not UserSetup."Delete Access" then Error('You dont have the acccess for deleting Opportunity');
        end;
    end;
}
