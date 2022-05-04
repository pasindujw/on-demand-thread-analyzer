## On-Demand Thread Analyzer

You can use the following script to trigger taking thread-dumps or JFRs when an API is taking high time to response.
Steps:
1. Download and take the script to the server.
2. Check configurations at the top of the script.
3. Set the `identification_term_for_jps` following below method:

The script is using 'JPS' command to identify the process-id of the process which you need to get thread-dumps. (Because the PID will vary when you restart that process).

Execute command **jps** in a terminal and you will see a set of java-processes.

Out of them, identify the one you want to examine and copy the name in that line.
i.e:
> 83829 Bootstrap
> 
> 45992 Jps
> 
> 52094 MacLauncher
> 
 
 This is an output in a Mac, where I'm running my application server. 
 
 MacLauncher is a Mac-owned process, and Jps is the process for our command. Therefore the process related to my application server is '83829'. 
 
 Note the term 'Bootstrap' which is what we have configure as `identification_term_for_jps` in the script.

4. Execute the script in background mode. (You can use nohup)
