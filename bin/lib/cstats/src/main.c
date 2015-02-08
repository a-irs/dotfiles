#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

const char *DIR = "/home/alex/.cstats";

char *uptime(char *buf) {

    // get first entry (seperated by whitespace) from file
    char line[100];
    FILE *fd;
    fd = fopen("/proc/uptime", "r");
    fgets(line, sizeof(line), fd);
    char *first;
    first = strtok(line, " ");

    // convert seconds to hours:minutes
    int hours = atoi(first) / 3600;
    int remainder = atoi(first) % 3600;
    int minutes = remainder / 60;

    // return as string in form h:mm
    sprintf(buf, "%d:%02d", hours, minutes);
    return buf;
}

char *loadavg(char *buf) {
    char *line = malloc(sizeof(char) * 100);
    FILE *fd;
    fd = fopen("/proc/loadavg", "r");
    fgets(line, 100, fd);

    char *first, *second, *third;
    first = strtok(line, " ");
    second = strtok(NULL, " ");
    third = strtok(NULL, " ");


    sprintf(buf, "%s %s %s", first, second, third);
    free(line);
    return buf;
}

float temp(char *buf) {
    FILE *fd;
    fd = fopen("/sys/class/thermal/thermal_zone0/temp", "r");
    fgets(buf, sizeof(buf), fd);

    return atof(buf) / 1000.;
}

char *datetime(char *buf) {
    time_t rawtime = time(NULL);
    struct tm *timeinfo;

    timeinfo = localtime(&rawtime);

    strftime(buf, sizeof(char) * 30, "%Y-%m-%d %H:%M", timeinfo);
    return buf;
}

char *month(char *buf) {
    time_t rawtime = time(NULL);
    struct tm *timeinfo;

    timeinfo = localtime(&rawtime);

    strftime(buf, sizeof(char) * 30, "%Y-%m", timeinfo);
    return buf;
}

void write_stats() {
    // filename
    char filename[254];
    char *month_buf = malloc(sizeof(char) * 30);
    snprintf(filename, sizeof filename, "%s%s%s%s", DIR, "/", month(month_buf), ".log");
    free(month_buf);
    printf("%s\n", filename);


    // open/make file
    mkdir(DIR, 0777);
    FILE *f;
    f = fopen(filename, "a");

    // write to file
    char *datetime_buf = malloc(sizeof(char) * 30);
    char *temp_buf = malloc(sizeof(char) * 20);
    char *loadavg_buf = malloc(sizeof(char) * 30);
    char *uptime_buf = malloc(sizeof(char) * 40);
    fprintf(f, "%s %s %s %.1f\n", datetime(datetime_buf), loadavg(loadavg_buf), uptime(uptime_buf), temp(temp_buf));

    // cleanup
    free(datetime_buf);
    free(temp_buf);
    free(loadavg_buf);
    free(uptime_buf);
    fclose(f);
}

int main(void) {
    while (1) {
        write_stats();
        sleep(60);
    }
    return 0;
}

