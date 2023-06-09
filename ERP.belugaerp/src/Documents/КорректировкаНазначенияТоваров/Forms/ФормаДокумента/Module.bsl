
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	бг_ДобавитьЭлементыРезервирования();
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&После("УстановитьВидимостьДоступность")
&НаСервере
Процедура бг_УстановитьВидимостьДоступность()
	Элементы.Товары.ИзменятьСоставСтрок = Истина;
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыРезервирования()
	
	ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Основание",
		Элементы.ГруппаОсновное,
		"Объект.бг_Основание",
		, // Тип поля, строка
		, // Элемент перед которым будет вставлен создаваемый элемент
		"ПолеВвода");
		
КонецПроцедуры

#КонецОбласти