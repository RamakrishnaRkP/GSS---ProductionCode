tableextension 60187 "Activities Cue Ext" extends "Activities Cue"
{
    fields
    {
        field(60000; "Open Opportunities"; Integer)
        {
            CalcFormula = Count(Opportunity WHERE(Closed=FILTER(false)));
            Caption = 'Open Opportunities';
            FieldClass = FlowField;
        }
        field(60001; "Closed Opportunities"; Integer)
        {
            CalcFormula = Count(Opportunity WHERE(Closed=FILTER(true)));
            Caption = 'Closed Opportunities';
            FieldClass = FlowField;
        }
        field(60002; "Opportunities Due in 7 Days"; Integer)
        {
            CalcFormula = Count("Opportunity Entry" WHERE(Active=FILTER(true), "Date Closed"=FILTER(0D), "Estimated Close Date"=FIELD("Due Date FilterOPP")));
            Caption = 'Opportunities Due in 7 Days';
            FieldClass = FlowField;
        }
        field(60003; "Overdue Opportunities"; Integer)
        {
            CalcFormula = Count("Opportunity Entry" WHERE(Active=FILTER(true), "Date Closed"=FILTER(0D), "Estimated Close Date"=FIELD("Overdue Date FilterOPP")));
            Caption = 'Overdue Opportunities';
            FieldClass = FlowField;
        }
        field(60004; "Due Date FilterOPP"; Date)
        {
            Caption = 'Due Date Filter';
            FieldClass = FlowFilter;
        }
        field(60005; "Overdue Date FilterOPP"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
    }
}
