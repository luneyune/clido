#include <stdio.h>
#include <time.h>

void create_task(char* filename, char *taskname, struct tm *day) {
    FILE *task_file;
    char time_buf[100];
    strftime(time_buf, sizeof time_buf, "%d.%m.%y", day);
    fopen_s(&task_file, filename, "a");
    fprintf(task_file, "%s %s\n", taskname, time_buf);
    fclose(task_file);
}

int main(int argc, char **argv)
{
    struct tm some_time;
    some_time.tm_year = 2026;
    some_time.tm_mon = 11;
    some_time.tm_mday = 15;
    create_task("tasks.txt", "Go to the concert with EGOR", &some_time);
}
