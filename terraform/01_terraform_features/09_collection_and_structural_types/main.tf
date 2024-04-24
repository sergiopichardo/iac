terraform {}

variable "planets" {
    type = list
    default = ["earth", "mars", "moon"]
}

variable "plans" {
    type = map 
    default = {
        "PlanA" = "10 USD"
        "PlanB" = "50 USD"
        "PlanC" = "100 USD"
    }
}

variable "plan" {
    type = object({
      PlanName = string
      PlanAmount = number
    })

    default = {
        "PlanName" = "Basic"
        "PlanAmount" = 10
    }
}

# values of a tuple must match the type definition
variable "random" {
    type = tuple([string, number, bool])
    default = ["hello", 22, false]
}

