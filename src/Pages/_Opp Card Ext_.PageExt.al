pageextension 60182 "Opp Card Ext" extends "Opportunity Card"
{
    layout
    {
        addafter("Contact Name")
        {
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
                ShowMandatory = true;

                trigger OnValidate()
                begin
                //Rec.TestField("Salesperson Code");
                end;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Pre-Sale Required"; Rec."Pre-Sale Required")
            {
                ApplicationArea = All;
            }
            field("Pre-Sales Person"; Rec."Pre-Sales Person")
            {
                ApplicationArea = All;
            }
            field("Pre-SalesPerson Name"; Rec."Pre-SalesPerson Name")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Update)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Salesperson Code");
            end;
        }
        modify(CloseOpportunity)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Salesperson Code");
            end;
        }
        modify("Create &Interaction")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Salesperson Code");
            end;
        }
        modify("Activate the First Stage")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Salesperson Code");
            end;
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Customer Type":=Rec."Customer Type"::" ";
    end;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean begin
        Rec."Customer Type":=Rec."Customer Type"::" ";
    end;
    trigger OnModifyRecord(): Boolean begin
        if Rec."Customer Type" = Rec."Customer Type"::ExisitingCustomer then Rec.TestField("Contact No.");
    end;
    trigger OnQueryClosePage(CloseAction: Action): Boolean begin
        Rec.Modify();
        CurrPage.Update(true);
        if((Rec."Customer Type" = Rec."Customer Type"::" ") or (Rec."Salesperson Code" = '') or (Rec.Description = '') or (Rec."Global Dimension 1 Code" = '') or (Rec."Contact No." = ''))then Error('Please enter all details');
    end;
}
