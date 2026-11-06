tableextension 60108 GSSJob extends Job
{
    fields
    {
        field(50000; "Customer Credit Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Sales Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Delivery Exception allowed"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Delivery Exc. allowed by User" := UserId;
            end;
        }
        field(50003; "Delivery Exc. allowed by User"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "Need Finance Approval"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50005; "Invoice Exception allowed"; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Invoice Exc. allowed by User" := UserId;
            end;
        }
        field(50006; "Invoice Exc. allowed by User"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Invoice Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Shipment Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60100; GSSStatus; Enum "GSSJob Document Status")
        {
            Editable = false;
            Caption = 'Document Status';
            DataClassification = ToBeClassified;
        }
        field(60101; "GSSSalesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                SalespersonTeams: record "Team Salesperson";
            begin
                TestStatusOpen();
                SalespersonTeams.SetCurrentKey("Team Code", "Salesperson Code");
                SalespersonTeams.SetRange("Salesperson Code", "GSSSalesperson Code");
                if SalespersonTeams.FindFirst() then
                    Validate("GSSTeam", SalespersonTeams."Team Code")
                else
                    Validate(GSSTeam, '');
            end;
        }
        field(60102; "GSSTeam"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Team';
            TableRelation = Team.Code;
            Editable = false;
        }
        field(60110; "GSSTotal Budgeted Cost"; Decimal)
        {
            Caption = 'Total Budget Cost';
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Total Cost" where("Job No." = field("No."), "Line Type" = filter(Budget | "Both Budget and Billable")));
            Editable = false;
        }
        field(60111; "GSSTotal Billable Price"; Decimal)
        {
            Caption = 'Total Billable Price';
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Line Amount" where("Job No." = field("No."), "Line Type" = filter(Billable | "Both Budget and Billable")));
            Editable = false;
        }
        field(60112; "GSSGross Margin %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Margin %';
            Editable = false;
        }
        field(60113; "GSSTotal Budgeted Price"; Decimal)
        {
            Caption = 'Total Budgeted Price';
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Line Amount" where("Job No." = field("No."), "Line Type" = filter(Budget | "Both Budget and Billable")));
            Editable = false;
        }
        field(60120; "GSSPurchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
        }
        field(60130; "GSSExternal Document No."; Code[35])
        {
            Caption = 'Customer PO No.';
            DataClassification = CustomerContent;
        }
        field(60131; "GSSCustomer PO Amount"; Decimal)
        {
            Caption = 'Customer PO Amount';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //TestStatusOpen();                
            end;
        }
        field(60140; "GSSGross Margin"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Margin ';
            Editable = false;
        }
        field(60145; "GSSWIP Calc. Required"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'WIP Calc. Requierd';
            Editable = false;
        }
        field(60146; "Sales Quote No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Quote));
        }
        field(60147; "Email Triggered"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Email Triggered';
        }
        field(60148; "Customer PO Received"; Boolean)
        {
            Caption = 'Customer PO Received';
            DataClassification = CustomerContent;
        }
        field(60149; Cust_BalanceLCY; Decimal)
        {
            Caption = 'Customer Balance(LCY)';
            Editable = false;
            //FieldClass = FlowField;
            // CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Sell-to Customer No.")));
        }
        field(60150; Cust_BalanceDueLCY; Decimal)
        {
            Caption = 'Customer Balance Due(LCY)';
            Editable = false;
            //  FieldClass = FlowField;
            //  CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Sell-to Customer No.")));
        }
        field(60151; Cust_CreditLimitLCY; Decimal)
        {
            Caption = 'Customer Credit Limit(LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Credit Limit (LCY)" where("No." = field("Sell-to Customer No.")));
        }
        field(60152; Cust_CreditInsuranceLimitLCY; Decimal)
        {
            Caption = 'Customer Credit Insurance Limit(LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."GSSCredit Insurance Limit(LCY)" where("No." = field("Sell-to Customer No.")));
        }
        field(60153; Cust_BalanceLCY2; Decimal)
        {
            Caption = 'Customer Balance(LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Sell-to Customer No.")));
        }
        field(60154; Cust_BalanceDueLCY2; Decimal)
        {
            Caption = 'Customer Balance Due(LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Sell-to Customer No.")));
        }
        field(60155; "Opportunity ID"; Code[20])
        {
            Caption = 'Opportunity ID';
            DataClassification = CustomerContent;
            TableRelation = Opportunity."No.";

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }

        /////Rk
        field(60156; "Need Exception Approval"; Boolean)
        {
            Caption = 'Need Exception Approval';
            DataClassification = CustomerContent;
            //editable = false;
        }

        field(50104; "Available Credit Amount"; Decimal)
        {
            Caption = 'Available Credit Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        /////Rk


        ////Rk271026
        field(50105; "Credit Exposure"; Decimal)
        {
            Caption = 'Credit Exposure';
            DataClassification = CustomerContent;
            Editable = false;
        }
        modify("Allow Schedule/Contract Lines")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Apply Usage Link")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Address 2")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Address")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to City")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Contact No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Country/Region Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to County")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Customer No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Name")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Bill-to Post Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Creation Date")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Currency Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Ending Date")
        {
            trigger OnBeforeValidate()
            begin
                //TestStatusOpen();
            end;
        }
        modify("Exch. Calculation (Cost)")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Exch. Calculation (Price)")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO No.';
        }
        modify("Invoice Currency Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Job Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Person Responsible")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Project Manager")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                CustRec: Record Customer;
            begin
                if CustRec.Get(Rec."Sell-to Customer No.") then begin
                    CustRec.CalcFields("Balance (LCY)", "Balance Due (LCY)");
                    Rec.Cust_BalanceLCY := CustRec."Balance (LCY)";
                    Rec.Cust_BalanceDueLCY := CustRec."Balance Due (LCY)";
                end;
            end;
        }
        modify("Starting Date")
        {
            trigger OnBeforeValidate()
            begin
                //TestStatusOpen();
            end;
        }
        modify("WIP Method")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("WIP Posting Method")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
    }
    trigger OnBeforeDelete()
    begin
        Error('Job cannot be deleted!');
    end;

    trigger OnBeforeModify()
    begin
        //Updating the creation date as this might become blank when the bill to customer no is deleted by the user
        //Upon validating bill to contact number, standard calls the INIT function which resets the value for the field.
        //We are checking if the creation date is blank in the current record and if the value was there in the previous record
        //We are updating the same in current record.
        //
        // Exception: The code will not work in the case if we want to make the date as blank.
        if (Rec."Creation Date" = 0D) and (xRec."Creation Date" <> 0D) then begin
            Rec."Creation Date" := xRec."Creation Date";
            //Rec.Modify(false); // IT should be false so that id doesn't go into infinite loop for Modify trigger
        end;
    end;

    local procedure TestStatusOpen()
    begin
        TestField(GSSStatus, GSSStatus::Open);
    end;

    procedure TestStatusReleased()
    var
        myInt: Integer;
    begin
        TestField(GSSStatus, GSSStatus::Released);
    end;

    procedure TestSalespersonCode()
    var
        JobsSetup: Record "Jobs Setup";
    begin
        //check for mandatory salesperson code
        Clear(JobsSetup);
        if JobsSetup.Get() then begin
            if JobsSetup."GSSSalesperson Code Mandatory" then begin
                Rec.TestField("GSSSalesperson Code");
                Rec.TestField(GSSTeam);
            end;
        end;
    end;
}
