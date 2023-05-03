
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ПриОткрытииПосле(Отказ)
	
	бг_УстановитьВидимостьЭлементаГоловнойКонтрагент();
	бг_УстановитьВидимостьЭлементаРозничныйПокупатель();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура бг_ВидКонтрагентаПриИзмененииПосле(Элемент)
	
	бг_УстановитьВидимостьЭлементаГоловнойКонтрагент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура бг_ДобавитьЭлементыФормы()
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_EDI_ИД",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_EDI_ИД");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_EDI_Наименование",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_EDI_Наименование");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_GLNПолучателя",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_GLNПолучателя");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ВыгружатьШтрихкодEAN13ВТТНЕГАИС",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ВыгружатьШтрихкодEAN13ВТТНЕГАИС",
		, //ТипЭлемента,
		, //Элемент
		"ПолеФлажка");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ЗаполнятьДопДанныеВИсхТТНЕГАИС",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ЗаполнятьДопДанныеВИсхТТНЕГАИС",
		, //ТипЭлемента,
		, //Элемент
		"ПолеФлажка");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ИнформацияЧКН",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ИнформацияЧКН");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодКлиентаSY",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_КодКлиентаSY");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодПроизводителейИМаркировщиковИмпорта",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_КодПроизводителейИМаркировщиковИмпорта");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;

	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодSAP",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_КодSAP");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КППКрупнейшегоНалогоплательщика",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_КППКрупнейшегоНалогоплательщика");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ЛичноеПоручительство",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ЛичноеПоручительство",
		, //ТипЭлемента,
		, //Элемент
		"ПолеФлажка");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_МакетПечатныхФорм",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_МакетПечатныхФорм");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_НаименованиеКонтрагентаВБанкеФакторе",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_НаименованиеКонтрагентаВБанкеФакторе");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ЦФО",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ЦФО");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ГоловнойКонтрагент",
		Элементы.ГруппаНаименованияПартнер,
		"Объект.бг_ГоловнойКонтрагент");
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ФирмаПроизводитель",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ФирмаПроизводитель");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Код",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Код");
		
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_РозничныйПокупатель",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_РозничныйПокупатель");
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
  
  	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_РазделятьРеализацииПоСериямНоменклатуры",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_РазделятьРеализацииПоСериямНоменклатуры");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
  	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ОтгружатьВЗаказеТолькоОднуПартию",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ОтгружатьВЗаказеТолькоОднуПартию");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Тикер",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Тикер");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_УстановитьВидимостьЭлементаГоловнойКонтрагент()
	
	Элементы.бг_ГоловнойКонтрагент.Видимость = 
		Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_УстановитьВидимостьЭлементаРозничныйПокупатель()
	
	Элементы.бг_РозничныйПокупатель.Видимость = бг_ЭтоПолноправныйПользователь();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_ЭтоПолноправныйПользователь()
	
	Возврат Пользователи.РолиДоступны("ПолныеПрава");
	
КонецФункции

#КонецОбласти
