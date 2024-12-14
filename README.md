# Database-Size-Monitoring

Monitor database size growth and issue alerts
---
Monitor incremental changes in the database through scheduled tasks, display change trends through charts, set alarm thresholds, and write information to messages.log

---
Implemented from idea:

`https://ideas.intersystems.com/ideas/DPI-I-626`
## How to use it

You need to create a scheduled task with the task class DataBases.Taks.DataCapture and configure some information
- AlarmSize ：Database size alarm
- DayActualSize	: Daily increase in alarm volume size
- IncrementalSize ：Atual total increase in alarm volume size

#### If the database size changes by more than the specified value, other information will be written to `messages.log`
---

### At the same time, you can count the incremental trends of the database. You can visit the following page
` http://127.0.0.1:52773/csp/user/DataBases.Page.Chart.cls`

- `tip:` If you cannot access the Page, you may need to adjust  and Web application and change the server file of `/csp/user` to `always and cache`.
---
### Prerequisites
Make sure you have git and Docker desktop installed.
### Installation
#### 1.Clone/git pull the repo into any local directory
```
git clone https://github.com/Sara771dev/Database-Size-Monitoring.git
```  
#### Open the terminal in this directory and run

```
docker-compose build
```
#### Run the IRIS container 

```
docker-compose up -d
```