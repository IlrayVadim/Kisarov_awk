echo "Отчет сохранен в файле report.txt"

# общее кол-во запросов
echo -e "Отчет о логе веб-сервера\n========================" > report.txt
a=$(cat access.log | awk 'END{print NR}')
echo "Общее количество запросов: $a" >> report.txt

# уникальные IP
sum=0
b=$(awk '{count[$1]++} END {for (val in count) {sum++} print sum}' access.log)
echo "Количество уникальных IP-адресов: $b" >> report.txt

# кол-во запросов по методам
echo -e "\n\nКоличество запросов по методам:" >> report.txt
awk '
	BEGIN {
		split("PUT DELETE GET POST", arr)
	}
	{
		for (i in arr){
			if ($0 ~ arr[i]){
				count[arr[i]]++
			}
		}
	}
       	END {
		for (val in count){
			print "\t" count[val], val "\n"
		}
	}' access.log | sort -rn >> report.txt

# самый популярный URL
awk 'BEGIN {
		max=0; ip=""
	}
       	{
		count[$7]++
	}
       	END {
		for (val in count) {
			if (count[val]>=max){
				max=count[val]; ip=val
			}
		} 
	       	print "Самый популярный URL:   " max, ip

	}' access.log | sort -r -k2 >> report.txt
