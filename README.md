# README

## Business Requirements:

- [x] All requests should respond with the correct HTTP status codes and a response, if necessary, representing either the success or error conditions.
- [x] Data should be persisted using some flavor of SQL.
- [x] Each dinosaur must have a name.
- [x] Each dinosaur is considered an herbivore or a carnivore, depending on its species.
- [x] Carnivores can only be in a cage with other dinosaurs of the same species.
- [x] Each dinosaur must have a species
- [x] Herbivores cannot be in the same cage as carnivores.
- [x] Use Carnivore dinosaurs like Tyrannosaurus, Velociraptor, Spinosaurus and Megalosaurus.
- [x] Use Herbivores like Brachiosaurus, Stegosaurus, Ankylosaurus and Triceratops.


## Technical Requirements:
- [x] This project should be done in Ruby on Rails 6 or newer. This should be done using version control, preferably git.
- [x] The project should include a README that addresses anything you may not have completed.
- [x] It should also address what additional changes you might need to make if the application were intended to run in a concurrent environment. Any other comments or thoughts about the project are also welcome.

## Bonus Points:

- [x] Cages have a maximum capacity for how many dinosaurs it can hold. Cages know how many dinosaurs are contained.
- [x] Cages have a power status of ACTIVE or DOWN.
- [x] Cages cannot be powered off if they contain dinosaurs.
- [x] Dinosaurs cannot be moved into a cage that is powered down.
- [x] Must be able to query a listing of dinosaurs in a specific cage.
- [x] When querying dinosaurs or cages they should be filterable on their attributes (Cages on their power status and dinosaurs on species).
- [x] Automated tests that ensure the business logic implemented is correct.

## To Do:

- add transactions around the dinosaur create, because it's assigned to a cage when created, it causes an increment to the assoicated cage which may fail (too many dinosaurs).
- add transactions around the move cage logic.
- add testing around adding too many dinosaurs
- **Transactions** would also help address race conditions if running in a concurrent environment
- Refactor, 
  - I went for the simplest way to represent the dinosaurs and cages, if I spent more time on it I'd set up relationships between the database tables. 
  - Move the increment and decrement code to the Cage class
  
