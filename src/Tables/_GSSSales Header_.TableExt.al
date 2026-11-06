tableextension 60123 "GSSSales Header" extends "Sales Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Job No." where("Document Type" = field("Document Type"), "Document No." = field("No."), "Job No." = filter(<> '')));
        }
        modify("Salesperson Code")
        {
            trigger OnAfterValidate()
            var
                SalespersonTeams: record "Team Salesperson";
            begin

                TestStatusOpen();

                SalespersonTeams.SetCurrentKey("Team Code", "Salesperson Code");
                SalespersonTeams.SetRange("Salesperson Code", Rec."Salesperson Code");
                if SalespersonTeams.FindFirst() then
                    Validate("GSSTeam", SalespersonTeams."Team Code")
                else
                    Validate(GSSTeam, '');
            end;
        }

        field(60102; "GSSTeam"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Team';
            TableRelation = Team.Code;
            Editable = false;
        }

        // field(60110; "GSSTotal Budgeted Cost"; Decimal)
        // {
        //     Caption = 'Total Budget Cost';
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Job Planning Line"."Total Cost" where("Job No." = field("No."), "Line Type" = filter(Budget | "Both Budget and Billable")));
        //     Editable = false;
        // }
        // field(60111; "GSSTotal Billable Price"; Decimal)
        // {
        //     Caption = 'Total Billable Price';
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Job Planning Line"."Line Amount" where("Job No." = field("No."), "Line Type" = filter(Billable | "Both Budget and Billable")));
        //     Editable = false;
        // }
        field(60140; "GSSGross Margin"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Margin ';
            Editable = false;
        }
        field(60112; "GSSGross Margin %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Margin %';
            Editable = false;
        }
        // field(60113; "GSSTotal Budgeted Price"; Decimal)
        // {
        //     Caption = 'Total Budgeted Price';
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Job Planning Line"."Line Amount" where("Job No." = field("No."), "Line Type" = filter(Budget | "Both Budget and Billable")));
        //     Editable = false;
        // }
        field(60113; "Reason For Retun"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason For Retun';
            // Editable = false;
        }
    }
}
