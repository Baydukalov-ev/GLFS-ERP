
#Область ОбработчикиСобытийФормы

&НаСервере
&Вместо("ПриСозданииНаСервере")
Процедура бг_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Партнер") Тогда
		Партнер = Параметры.Партнер;
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Партнер, СписокПартнеров);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Партнер",
			СписокПартнеров,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			Истина);
	ИначеЕсли Параметры.Отбор.Свойство("Владелец") Тогда
		Владелец = Параметры.Отбор.Владелец;
//#Вставка
		ГоловнойКонтрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ГоловнойКонтрагент");
		Если ЗначениеЗаполнено(ГоловнойКонтрагент) Тогда
			Параметры.Отбор.Владелец = ГоловнойКонтрагент; 
		КонецЕсли;
//#КонецВставки
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "Контрагент",
			"Видимость", Ложь);
	КонецЕсли;

//#Вставка
	бг_ИзменитьТекстЗапросаСписка();
	бг_ДобавитьЭлементыНаФорму();
//#КонецВставки

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область Служебные

&НаСервере
Процедура бг_ИзменитьТекстЗапросаСписка()
	
	ПодстрокаЗамены = 
	"ВЫБРАТЬ
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_Регион КАК Регион,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_ВидЛицензируемойДеятельности КАК ВидЛицензируемойДеятельности,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_ДатаВыдачи КАК ДатаВыдачи,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_ДатаПрекращенияДействия КАК ДатаПрекращенияДействия,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_ЗаменяемаяЛицензия КАК ЗаменяемаяЛицензия,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_Номер КАК Номер,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_НомерРАР КАК НомерРАР,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_ПриостановленаСДаты КАК ПриостановленаСДаты,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_Серия КАК Серия,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_СлабоалкогольнаяПродукция КАК СлабоалкогольнаяПродукция,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_ТипЛицензии КАК ТипЛицензии,
	|	СправочникЛицензииПоставщиковАлкогольнойПродукции.бг_Хорека КАК Хорека,";
	ТекстЗапроса = Список.ТекстЗапроса;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫБРАТЬ", ПодстрокаЗамены);
	Список.ТекстЗапроса = ТекстЗапроса;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыНаФорму()
	
	бг_Регион = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_Регион",
					Элементы.Список,
					"Список.Регион");
					
	бг_ВидЛицензируемойДеятельности = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
										ЭтотОбъект,
										"бг_ВидЛицензируемойДеятельности",
										Элементы.Список,
										"Список.ВидЛицензируемойДеятельности");
										
	бг_ДатаВыдачи = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_ДатаВыдачи",
						Элементы.Список,
						"Список.ДатаВыдачи");
						
	бг_ДатаПрекращенияДействия = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
									ЭтотОбъект,
									"бг_ДатаПрекращенияДействия",
									Элементы.Список,
									"Список.ДатаПрекращенияДействия");
									
	бг_ЗаменяемаяЛицензия = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
								ЭтотОбъект,
								"бг_ЗаменяемаяЛицензия",
								Элементы.Список,
								"Список.ЗаменяемаяЛицензия");
								
	бг_Номер = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_Номер",
					Элементы.Список,
					"Список.Номер");
					
	бг_НомерРАР = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_НомерРАР",
					Элементы.Список,
					"Список.НомерРАР");
					
	бг_ПриостановленаСДаты = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_ПриостановленаСДаты",
					Элементы.Список,
					"Список.ПриостановленаСДаты");
					
	бг_Серия = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_Серия",
					Элементы.Список,
					"Список.Серия");
					
	бг_СлабоалкогольнаяПродукция = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_СлабоалкогольнаяПродукция",
					Элементы.Список,
					"Список.СлабоалкогольнаяПродукция");
					
	бг_ТипЛицензии = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_ТипЛицензии",
					Элементы.Список,
					"Список.ТипЛицензии");
					
	бг_Хорека = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
					ЭтотОбъект,
					"бг_Хорека",
					Элементы.Список,
					"Список.Хорека");
					
КонецПроцедуры

#КонецОбласти
