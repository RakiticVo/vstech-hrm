"""Shared PlantUML styling for the IP-registration diagrams."""

SEQ_STYLE = r"""
skinparam dpi 160
skinparam defaultFontName Arial
skinparam defaultFontSize 12
skinparam shadowing false
skinparam roundCorner 8
skinparam maxMessageSize 230
skinparam sequenceMessageAlign left
skinparam responseMessageBelowArrow true
skinparam ParticipantPadding 4
skinparam BoxPadding 4
skinparam titleFontSize 16
skinparam titleFontStyle bold
skinparam titleFontColor #0A544E
skinparam sequence {
  ArrowColor #0F766E
  ArrowThickness 1.2
  LifeLineBorderColor #94A3B8
  LifeLineBackgroundColor #CCFBF1
  ParticipantBorderColor #0F766E
  ParticipantBackgroundColor #FFFFFF
  ParticipantFontStyle bold
  ActorBorderColor #0F766E
  ActorBackgroundColor #FFF8EC
  BoxBorderColor #CBD5E1
  GroupBorderColor #B45309
  GroupBackgroundColor #FFFBEB
  GroupHeaderFontColor #92400E
  DividerBackgroundColor #F0FDFA
  DividerBorderColor #0F766E
  ReferenceBackgroundColor #F8FAFC
}
skinparam note {
  BackgroundColor #FFF8EC
  BorderColor #F59E0B
  FontSize 11
}
"""

GENERIC_STYLE = r"""
!pragma layout smetana
skinparam dpi 160
skinparam defaultFontName Arial
skinparam defaultFontSize 12
skinparam shadowing false
skinparam roundCorner 10
skinparam titleFontSize 16
skinparam titleFontStyle bold
skinparam titleFontColor #0A544E
skinparam ArrowColor #0F766E
skinparam componentStyle rectangle
skinparam rectangle {
  BorderColor #0F766E
  BackgroundColor #FFFFFF
}
skinparam package {
  BorderColor #0A544E
  BackgroundColor #F0FDFA
  FontColor #0A544E
}
skinparam node {
  BorderColor #0A544E
  BackgroundColor #F8FAFC
}
skinparam database {
  BorderColor #0A544E
  BackgroundColor #ECFEFF
}
skinparam cloud {
  BorderColor #B45309
  BackgroundColor #FFFBEB
}
skinparam note {
  BackgroundColor #FFF8EC
  BorderColor #F59E0B
}
skinparam class {
  BorderColor #0F766E
  BackgroundColor #FFFFFF
  HeaderBackgroundColor #CCFBF1
  ArrowColor #0F766E
}
skinparam state {
  BorderColor #0F766E
  BackgroundColor #F0FDFA
  ArrowColor #0F766E
}
"""

# Colours of layer boxes in mobile-tier sequence diagrams.
BOX_UI = "#E6F4F1"
BOX_DOMAIN = "#FEF9E7"
BOX_DATA = "#EEF2FF"
BOX_DEVICE = "#F1F5F9"
BOX_SERVER = "#FFF1F2"


def seq(title: str, body: str, autonumber: bool = True) -> str:
    num = 'autonumber "<b>00."' if autonumber else ""
    return f"@startuml\n{SEQ_STYLE}\n{num}\ntitle {title}\n{body.strip()}\n@enduml\n"


def generic(title: str, body: str, extra: str = "") -> str:
    return f"@startuml\n{GENERIC_STYLE}\n{extra}\ntitle {title}\n{body.strip()}\n@enduml\n"
