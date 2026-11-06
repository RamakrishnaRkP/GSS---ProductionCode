pageextension 60119 "GSSJobs Setup" extends "Jobs Setup"
{
    layout
    {
        addlast(General)
        {
            field("GSSSalesperson Code Mandatory"; Rec."GSSSalesperson Code Mandatory")
            {
                ApplicationArea = All;
            }
            field("GSSRecognised Sales By Dim."; Rec."GSSRecognised Sales By Dim.")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Default WIP Method")
        {
            field("GSSAuto Calc. Job WIP"; Rec."GSSAuto Calc. Job WIP")
            {
                ApplicationArea = All;
            }
            field("GSSAuto Post Job WIP"; Rec."GSSAuto Post Job WIP")
            {
                ApplicationArea = All;
            }
            field("GSSAuto Complete Job"; Rec."GSSAuto Complete Job")
            {
                ApplicationArea = All;
            }
        }
    }
}
