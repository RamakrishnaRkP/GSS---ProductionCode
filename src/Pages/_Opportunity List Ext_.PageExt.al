pageextension 60183 "Opportunity List Ext" extends "Opportunity List"
{
    layout
    {
        addafter(Description)
        {
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
            }
        }
        modify("Calcd. Current Value (LCY)")
        {
            Visible = false;
        }
        moveafter("Estimated Value (LCY)"; Closed)
        moveafter("Contact No."; "Contact Name")
        addafter("Contact Name")
        {
            field(ContactEmail; GlobalContact."E-Mail")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Email';
                Editable = false;
                ExtendedDatatype = EMail;
                ToolTip = 'Specifies the email address of the contact to which this opportunity is linked.';
            }
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Campaign Description")
        {
            Visible = false;
        }
        modify("Sales Document No.")
        {
            Visible = false;
        }
        modify("Sales Document Type")
        {
            Visible = false;
        }
    }
    actions
    {
        modify(Update)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Salesperson Code" = '' then Error('Salesperson code is blank');
            end;
        }
        modify(Close)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Salesperson Code" = '' then Error('Salesperson code is blank');
            end;
        }
        modify("Create &Interaction")
        {
            trigger OnBeforeAction()
            begin
                if Rec."Salesperson Code" = '' then Error('Salesperson code is blank');
            end;
        }
    }
    trigger OnAfterGetRecord()
    begin
        GlobalContact.GetOrClear(Rec."Contact No.");
    end;
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    var GlobalContact: Record Contact;
    UserSetup: Record "User Setup";
}
