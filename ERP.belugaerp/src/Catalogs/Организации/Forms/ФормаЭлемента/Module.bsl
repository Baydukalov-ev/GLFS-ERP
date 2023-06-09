#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьПоля();
	бг_УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура бг_ВестиУчетАкцизовПоПриобретеннымЦенностямПриИзменении(Элемент)
	бг_УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьПоля()

	СтраницаДополнительныеСвойстваБелуга = Элементы.Добавить(
		"бг_ГруппаДополнительныеСвойстваБелуга",
		Тип("ГруппаФормы"), 
		Элементы.СтраницыПараметрыОрганизации);
	СтраницаДополнительныеСвойстваБелуга.Вид = ВидГруппыФормы.Страница;	
	СтраницаДополнительныеСвойстваБелуга.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	СтраницаДополнительныеСвойстваБелуга.Заголовок = НСтр("ru = 'Дополнительные свойства (Белуга)'");
	
	КодНСИ = Элементы.Добавить(
		"бг_КодНСИ",
		Тип("ПолеФормы"),
		СтраницаДополнительныеСвойстваБелуга);
	КодНСИ.Вид = ВидПоляФормы.ПолеВвода;
	КодНСИ.ПутьКДанным = "Объект.бг_КодНСИ";	
	КодНСИ.АвтоМаксимальнаяШирина = Ложь;
	КодНСИ.МаксимальнаяШирина = 28;

	Тикер = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Тикер",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_Тикер");
	Тикер.АвтоМаксимальнаяШирина = Ложь;
	Тикер.МаксимальнаяШирина = 28;
	
	КодSAP = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодSAP",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_КодSAP");
	КодSAP.АвтоМаксимальнаяШирина = Ложь;
	КодSAP.МаксимальнаяШирина = 28;

	ПроверятьЗаполнениеТранспортнойИнформацииПродажи = Элементы.Добавить(
		"бг_ПроверятьЗаполнениеТранспортнойИнформацииПродажи",
		Тип("ПолеФормы"),
		СтраницаДополнительныеСвойстваБелуга);
	ПроверятьЗаполнениеТранспортнойИнформацииПродажи.Вид = ВидПоляФормы.ПолеФлажка;
	ПроверятьЗаполнениеТранспортнойИнформацииПродажи.ПутьКДанным = "Объект.бг_ПроверятьЗаполнениеТранспортнойИнформацииПродажи";
	ПроверятьЗаполнениеТранспортнойИнформацииПродажи.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	
	ПродажаАлкогольнойПродукции = Элементы.Добавить(
		"бг_ПродажаАлкогольнойПродукции",
		Тип("ПолеФормы"),
		СтраницаДополнительныеСвойстваБелуга);
	ПродажаАлкогольнойПродукции.Вид = ВидПоляФормы.ПолеФлажка;
	ПродажаАлкогольнойПродукции.ПутьКДанным = "Объект.бг_ПродажаАлкогольнойПродукции";
	ПродажаАлкогольнойПродукции.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	
	ПолеМинимальнаяОтпускнаяЦена = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтаФорма,
		"бг_МинимальнаяОтпускнаяЦена",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_МинимальнаяОтпускнаяЦена");
	ПолеМинимальнаяОтпускнаяЦена.ОтображениеПодсказки = ОтображениеПодсказки.Авто;
	ПолеМинимальнаяОтпускнаяЦена.АвтоМаксимальнаяШирина = Ложь;
	ПолеМинимальнаяОтпускнаяЦена.МаксимальнаяШирина = 28;
	
	ПолеСтатьяСписанияТехнологическихПотерь = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_СтатьяСписанияТехнологическихПотерь",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_СтатьяСписанияТехнологическихПотерь");
	ПолеСтатьяСписанияТехнологическихПотерь.АвтоМаксимальнаяШирина = Ложь;
	ПолеСтатьяСписанияТехнологическихПотерь.МаксимальнаяШирина = 28;
	
	ПолеВестиУчетАкцизов = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ВестиУчетАкцизовПоПриобретеннымЦенностям",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_ВестиУчетАкцизовПоПриобретеннымЦенностям", , ,
		"ПолеФлажка");
	ПолеВестиУчетАкцизов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	ПолеВестиУчетАкцизов.УстановитьДействие("ПриИзменении", "бг_ВестиУчетАкцизовПоПриобретеннымЦенностямПриИзменении");
	
	ПолеДатаНачалаУчетаАкцизов = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ДатаНачалаУчетаАкцизовПоПриобретеннымЦенностям",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_ДатаНачалаУчетаАкцизовПоПриобретеннымЦенностям");
		
	ПолеСтатьяСписанияНормативныхПотерьПоАкцизам = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_СтатьяСписанияНормативныхПотерьПоАкцизам",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_СтатьяСписанияНормативныхПотерьПоАкцизам");
	ПолеСтатьяСписанияНормативныхПотерьПоАкцизам.АвтоМаксимальнаяШирина = Ложь;
	ПолеСтатьяСписанияНормативныхПотерьПоАкцизам.МаксимальнаяШирина = 28;
	
	ПолеАвтозаполнениеБанковскихГарантий = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_АвтозаполнениеБанковскихГарантий",
		СтраницаДополнительныеСвойстваБелуга,
		"Объект.бг_АвтозаполнениеБанковскихГарантий", , ,
		"ПолеФлажка");
	ПолеАвтозаполнениеБанковскихГарантий.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьДоступностьЭлементов()
	Элементы.бг_ДатаНачалаУчетаАкцизовПоПриобретеннымЦенностям.Видимость = Объект.бг_ВестиУчетАкцизовПоПриобретеннымЦенностям;
	Элементы.бг_СтатьяСписанияНормативныхПотерьПоАкцизам.Видимость       = Объект.бг_ВестиУчетАкцизовПоПриобретеннымЦенностям;
	Элементы.бг_АвтозаполнениеБанковскихГарантий.Видимость               = Объект.бг_ВестиУчетАкцизовПоПриобретеннымЦенностям;
КонецПроцедуры

#КонецОбласти
