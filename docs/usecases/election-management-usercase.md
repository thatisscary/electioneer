# Use Case #2 – Election Management

**Goal**  
A jurisdiction administrator (state, county, or local) can either **join** an existing election that affects their area or **create** a new local-only election.

**Primary Actor**  
Jurisdiction Admin (already approved via Use Case #1)

**Preconditions**  
- Admin is logged in with MFA  
- Admin belongs to a specific jurisdiction (state, county, city, etc.)

**Key Rules**  
- All decision-making authority remains at the **state level**  
- Federal contests (e.g., Presidential) are created at the state level and appear as “joinable” to lower jurisdictions  
- Primary elections are always state-level  
- Counties and cities may only **join** elections created by their state or **create local-only** elections (e.g., city council, bond measures)

**Main Success Scenario**

1. Admin navigates to **My Elections** dashboard  
2. Dashboard displays two sections:  
   a. **Elections I Can Join** – automatically populated from higher-level elections (state or federal)  
   b. **Create New Local Election** button (visible only if jurisdiction level permits local elections)  

3. **Option A – Join an existing election**  
   - Admin clicks **Join** next to an election (e.g., “2026 California General Election”)  
   - System adds their jurisdiction as a participant  
   - Admin immediately gains access to ballot design for that election  

4. **Option B – Create a new local election**  
   - Admin clicks **Create New Local Election**  
   - Enters:  
     - Election name  
     - Election date  
     - Voting period (start / end dates & times)  
     - Election type (General, Primary, Special, Referendum, etc.)  
   - System creates the election scoped exclusively to their jurisdiction  
   - Admin becomes the initial owner  

5. After either path, admin clicks **Proceed to Ballot Design** → enters Ballot domain workflow (Use Case #3 & #4)

**Postconditions**  
- Jurisdiction is officially participating in the selected election(s)  
- Election appears in all relevant admin dashboards and voter-facing systems

**Views Required**  
- My Elections dashboard (Joinable + My Local Elections)  
- Create Local Election form  
- Election Details page (participants, dates, status)

**Extensions / Notes**  
- A county/city admin cannot create a statewide or federal election – only state-level admins can  
- Once a state creates an election, it automatically becomes joinable for all subordinate jurisdictions