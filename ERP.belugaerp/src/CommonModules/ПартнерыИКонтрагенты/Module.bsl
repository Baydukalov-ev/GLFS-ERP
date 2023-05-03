
#Область ОбщиеПроцедурыИФункцииФормСпискаИВыбораСправочникаПартнеры

&ИзменениеИКонтроль("ИзменитьОтборСписок")
Процедура бг_ИзменитьОтборСписок(Форма, ПереформированиеПанелиНавигации, ТребуетсяЗаполнениеСтраницыСвойств)

	Если ТребуетсяЗаполнениеСтраницыСвойств Тогда

		Если Форма.ТипФильтра = "Категории" Тогда
			ЗаполнитьДеревоКатегорий(Форма);
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаКатегории;

			НайденныеСтроки = Форма.НастройкиПанелейНавигации.НайтиСтроки(Новый Структура("ВидПанели","Категории"));
			Если НайденныеСтроки.Количество() > 0 Тогда
				НайденныеСтрокиПанели = Форма.Категории.НайтиСтроки(Новый Структура("Значение", НайденныеСтроки[0].ТекущееЗначение));
				Если НайденныеСтрокиПанели.Количество() > 0 Тогда
					Форма.Элементы.Категории.ТекущаяСтрока = НайденныеСтрокиПанели[0].ПолучитьИдентификатор();
				КонецЕсли;
			КонецЕсли;

			Форма.НеОтрабатыватьАктивизациюПанелиНавигации = Истина;

#Вставка
		ИначеЕсли Форма.ТипФильтра = "бг_ГруппыПартнеров" Тогда
			бг_ЗаполнитьДеревоГруппПартнеров(Форма);
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.бг_СтраницаГруппыПартнеров;
			
			НайденныеСтроки = Форма.НастройкиПанелейНавигации.НайтиСтроки(Новый Структура("ВидПанели", Форма.ТипФильтра));
			Если НайденныеСтроки.Количество() > 0 Тогда
				Форма.Элементы.Свойства.ТекущаяСтрока = НайтиСтрокуВДанныхФормыДерево(Форма.Свойства, НайденныеСтроки[0].ТекущееЗначение, "Значение", Истина)
			КонецЕсли;

			Форма.НеОтрабатыватьАктивизациюПанелиНавигации = Истина;
#КонецВставки

		Иначе

			ЗаполнитьДеревоСвойств(Форма);
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаСвойства;

			НайденныеСтроки = Форма.НастройкиПанелейНавигации.НайтиСтроки(Новый Структура("ВидПанели", Форма.ТипФильтра));
			Если НайденныеСтроки.Количество() > 0 Тогда
				Форма.Элементы.Свойства.ТекущаяСтрока = НайтиСтрокуВДанныхФормыДерево(Форма.Свойства, НайденныеСтроки[0].ТекущееЗначение, "Значение", Истина)
			КонецЕсли;

			Форма.НеОтрабатыватьАктивизациюПанелиНавигации = Истина;

		КонецЕсли;

	КонецЕсли;

	УстанавливатьОтбор = Истина;
	Если НЕ Форма.ИспользоватьФильтр Тогда
		Форма.ТекущееЗначениеФильтра = Неопределено;
		УстанавливатьОтбор = Ложь;
	КонецЕсли;

	Если УстанавливатьОтбор ИЛИ Форма.ТолькоМои Тогда
		ГруппаОтбора = СоздатьГруппуОтбораПоФильтру(Форма);
	Иначе
		ГруппаОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементОтбораПоПредставлению(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Форма.Список).Элементы, "ОтборПоФильтру");
		Если ГруппаОтбора <> Неопределено Тогда
			ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Форма.Список).Элементы.Удалить(ГруппаОтбора);
		КонецЕсли;
	КонецЕсли;

	Если Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаСвойства 
#Вставка
		ИЛИ Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница.Имя = "бг_СтраницаГруппыПартнеров"
#КонецВставки
		ИЛИ Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаКатегории Тогда
		
		Форма.ТолькоЗначимые = Истина;
		Форма.Элементы.ТолькоЗначимые.Доступность = Ложь;
		ИмяРеквизитаОтбора = ?(Форма.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаВыбораИспользуютсяТолькоПартнеры" 
		ИЛИ Форма.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаВыбораИспользуютсяТолькоПартнерыБезПолнотекстовогоПоиска",
		"Партнер", "Ссылка");

	Иначе

		Форма.Элементы.ТолькоЗначимые.Доступность = Истина;

		Если ПереформированиеПанелиНавигации Тогда

			Если Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаБизнесРегионы Тогда
				НайденныеСтроки = Форма.НастройкиПанелейНавигации.НайтиСтроки(Новый Структура("ВидПанели", "БизнесРегионы"));
				Если НайденныеСтроки.Количество() > 0 Тогда
					Форма.Элементы.БизнесРегионы.ТекущаяСтрока = НайденныеСтроки[0].ТекущееЗначение;
				КонецЕсли;
				ИмяСписка = "БизнесРегионы";
			ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаГруппыДоступа Тогда
				НайденныеСтроки = Форма.НастройкиПанелейНавигации.НайтиСтроки(Новый Структура("ВидПанели", "ГруппыДоступа"));
				Если НайденныеСтроки.Количество() > 0 Тогда
					Форма.Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока = НайденныеСтроки[0].ТекущееЗначение;
				КонецЕсли;
				ИмяСписка = "ГруппыДоступаПартнеров";
			ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаМенеджеры Тогда
				НайденныеСтроки = Форма.НастройкиПанелейНавигации.НайтиСтроки(Новый Структура("ВидПанели", "Менеджер"));
				Если НайденныеСтроки.Количество() > 0 Тогда
					Форма.Элементы.Менеджеры.ТекущаяСтрока = НайденныеСтроки[0].ТекущееЗначение;
				КонецЕсли;
				ИмяСписка = "Менеджеры";
			КонецЕсли;

			ОтборСпискаДляИзменения = ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Форма[ИмяСписка]);
			СписокЗначимые = СписокЗначимыхЗначенийПанелиНавигации(ИмяСписка);

			Если ПереформированиеПанелиНавигации И НЕ Форма.ТолькоЗначимые Тогда
				ГруппаОтбораЗначимые = ОбщегоНазначенияКлиентСервер.НайтиЭлементОтбораПоПредставлению(ОтборСпискаДляИзменения.Элементы, "ОтборПоЗначимым");
				Если ГруппаОтбораЗначимые <> Неопределено Тогда
					ОтборСпискаДляИзменения.Элементы.Удалить(ГруппаОтбораЗначимые);
				КонецЕсли;
			Иначе
				ГруппаОтбораЗначимые = СоздатьГруппуОтбораЗначимые(ОтборСпискаДляИзменения);
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораЗначимые,
				"Ссылка",
				ВидСравненияКомпоновкиДанных.ВСписке,
				СписокЗначимые);
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Если Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаБизнесРегионы И ПозиционированиеКорректно("БизнесРегионы", Форма) Тогда

		Если УстанавливатьОтбор Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
			"БизнесРегион",
			ВидСравненияКомпоновкиДанных.Равно,
			Форма.Элементы.БизнесРегионы.ТекущаяСтрока);
		КонецЕсли;

		Форма.ТекущееЗначениеФильтра = Форма.Элементы.БизнесРегионы.ТекущаяСтрока;

	ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаГруппыДоступа И  ПозиционированиеКорректно("ГруппыДоступаПартнеров", Форма) Тогда

		Если УстанавливатьОтбор Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
			"ГруппаДоступа",
			ВидСравненияКомпоновкиДанных.Равно,
			Форма.Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока);
		КонецЕсли;

		Форма.ТекущееЗначениеФильтра = Форма.Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока;

	ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаМенеджеры И ПозиционированиеКорректно("Менеджеры", Форма) Тогда

		Если УстанавливатьОтбор Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
			"ОсновнойМенеджер",
			ВидСравненияКомпоновкиДанных.Равно,
			Форма.Элементы.Менеджеры.ТекущаяСтрока);
		КонецЕсли;

		Форма.ТекущееЗначениеФильтра = Форма.Элементы.Менеджеры.ТекущаяСтрока;

	ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаСвойства Тогда

		Если УстанавливатьОтбор Тогда

			Если Форма.Элементы.Свойства.ТекущаяСтрока <> Неопределено И ТипЗнч(Форма.Элементы.Свойства.ТекущаяСтрока) = Тип("Число") Тогда 
				ТекущиеДанные = Форма.Свойства.НайтиПоИдентификатору(Форма.Элементы.Свойства.ТекущаяСтрока);
				Если ТекущиеДанные <> Неопределено Тогда
					ЗначениеОтбора =  ТекущиеДанные.Значение;
				Иначе
					Возврат;
				КонецЕсли;
			Иначе
				Возврат
			КонецЕсли;

			Если ЗначениеОтбора = НСтр("ru = 'Не указан';
				|en = 'Not specified'") Тогда

				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
				ИмяРеквизитаОтбора + ".[" + Строка(Форма.ТипФильтра) + "]",
				ВидСравненияКомпоновкиДанных.НеЗаполнено)

			ИначеЕсли ЗначениеОтбора = НСтр("ru = 'Все';
				|en = 'All'") Тогда

				ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Форма.Список).Элементы.Удалить(ГруппаОтбора);
				Возврат;

			Иначе

				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
				ИмяРеквизитаОтбора + ".[" + Строка(Форма.ТипФильтра) + "]",
				ВидСравненияКомпоновкиДанных.Равно,
				ЗначениеОтбора);

			КонецЕсли;
		КонецЕсли;

		Форма.ТекущееЗначениеФильтра = ЗначениеОтбора;

	ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаКатегории Тогда

		Если УстанавливатьОтбор Тогда

			Если Форма.Элементы.Категории.ТекущаяСтрока <> Неопределено И ТипЗнч(Форма.Элементы.Категории.ТекущаяСтрока) = Тип("Число") Тогда 
				ТекущиеДанные = Форма.Категории.НайтиПоИдентификатору(Форма.Элементы.Категории.ТекущаяСтрока);
				Если ТекущиеДанные <> Неопределено Тогда
					ЗначениеОтбора =  ТекущиеДанные.Значение; // СправочникСсылка - 
				Иначе
					Возврат;
				КонецЕсли;
			Иначе
				Возврат
			КонецЕсли;

			Если ЗначениеОтбора <> НСтр("ru = 'Все';
				|en = 'All'") Тогда

				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
				ИмяРеквизитаОтбора + ".[" + ЗначениеОтбора.Наименование + "]",
				ВидСравненияКомпоновкиДанных.Равно,
				Истина);

			КонецЕсли;

			Форма.ТекущееЗначениеФильтра = ЗначениеОтбора;

		КонецЕсли;

#Вставка
	ИначеЕсли Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница.Имя = "бг_СтраницаГруппыПартнеров" Тогда

		Если УстанавливатьОтбор Тогда

			Если Форма.Элементы.бг_ГруппыПартнеров.ТекущаяСтрока <> Неопределено И ТипЗнч(Форма.Элементы.бг_ГруппыПартнеров.ТекущаяСтрока) = Тип("Число") Тогда 
				ТекущиеДанные = Форма.бг_ГруппыПартнеров.НайтиПоИдентификатору(Форма.Элементы.бг_ГруппыПартнеров.ТекущаяСтрока);
				Если ТекущиеДанные <> Неопределено Тогда
					ЗначениеОтбора = ТекущиеДанные.Значение;
				Иначе
					Возврат;
				КонецЕсли;
			Иначе
				Возврат
			КонецЕсли;

			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
				ГруппаОтбора, 
				"бг_ГруппаПартнера",
				ВидСравненияКомпоновкиДанных.ВИерархии,
				ЗначениеОтбора);
		КонецЕсли;
		
		Форма.ТекущееЗначениеФильтра = ЗначениеОтбора;
#КонецВставки

	КонецЕсли;

	Если Форма.ТолькоМои 
		И (НЕ Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаМенеджеры
		Или Не УстанавливатьОтбор) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора,
		"ОсновнойМенеджер",
		ВидСравненияКомпоновкиДанных.Равно,
		Форма.ТекущийПользователь);
	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("СписокЗначимыхЗначенийПанелиНавигации")
Функция бг_СписокЗначимыхЗначенийПанелиНавигации(ИмяСписка)

	Если ИмяСписка = "БизнесРегионы" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Партнеры.БизнесРегион КАК Ссылка
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры";

	ИначеЕсли ИмяСписка = "ГруппыДоступаПартнеров" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Партнеры.ГруппаДоступа КАК Ссылка
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры";

	ИначеЕсли ИмяСписка = "Менеджеры" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Партнеры.ОсновнойМенеджер КАК Ссылка
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры";

#Вставка
	ИначеЕсли ИмяСписка = "бг_ГруппыПартнеров" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Партнеры.бг_ГруппаПартнера КАК Ссылка
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры";
#КонецВставки
	КонецЕсли;

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");

КонецФункции

&ИзменениеИКонтроль("ПередЗагрузкойДанныхИзНастроекНаСервере")
Процедура бг_ПередЗагрузкойДанныхИзНастроекНаСервере(Форма, Настройки)

	ТипФильтраНастройки                  = Настройки.Получить("ТипФильтра");
	ТекущееЗначениеФильтраНастройки      = Настройки.Получить("ТекущееЗначениеФильтра");
	ИспользоватьФильтрНастройки          = Настройки.Получить("ИспользоватьФильтр");
	ИсторияВыбораСегментовНастройки      = Настройки.Получить("ИсторияВыбораСегментов");
	ТолькоЗначимыеНастройки              = Настройки.Получить("ТолькоЗначимые");
	Сегмент                              = Настройки.Получить("Сегмент");
	ТолькоМои                            = Настройки.Получить("ТолькоМои");

	Если ИсторияВыбораСегментовНастройки <> Неопределено Тогда
		Форма.Элементы.Сегмент.СписокВыбора.ЗагрузитьЗначения(ИсторияВыбораСегментовНастройки.ВыгрузитьЗначения());
	КонецЕсли;

	Если ТолькоМои <> Неопределено Тогда
		Форма.ТолькоМои = ТолькоМои;
		Настройки.Удалить("ТолькоМои");
		Если Форма.ИспользоватьФильтр И Форма.ТипФильтра = "Менеджер" Тогда
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ТолькоМои","Доступность", Ложь);
			Форма.ТолькоМои = Ложь;
		КонецЕсли;
	КонецЕсли;

	Если Сегмент <> Неопределено И Сегмент <> Справочники.СегментыПартнеров.ПустаяСсылка() Тогда

		Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список,
		"ОтборПоСегментуУстановлен",
		Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список,
		"ОтборПоСегменту",
		СегментыВызовСервера.СписокЗначений(Сегмент).ВыгрузитьЗначения());
	Иначе

		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список,
		"ОтборПоСегментуУстановлен",
		Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список,
		"ОтборПоСегменту",
		Неопределено);

	КонецЕсли;

	Если ТипФильтраНастройки = Неопределено  Тогда
		Возврат;
	ИначеЕсли Форма.Элементы.ТипФильтра.СписокВыбора.НайтиПоЗначению(ТипФильтраНастройки) <> Неопределено Тогда

		Форма.ТипФильтра = ТипФильтраНастройки;

		Если ТипЗнч(ТипФильтраНастройки) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения")Тогда
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаСвойства;
			ЗаполнитьДеревоСвойств(Форма);
			Форма.Элементы.Свойства.ТекущаяСтрока = НайтиСтрокуВДанныхФормыДерево(Форма.Свойства, ТекущееЗначениеФильтраНастройки, "Значение", Истина);
		ИначеЕсли Форма.ТипФильтра  = "Категории" Тогда
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаКатегории;
			ЗаполнитьДеревоКатегорий(Форма);
			НайденныеСтроки = Форма.Категории.НайтиСтроки(Новый Структура("Значение", ТекущееЗначениеФильтраНастройки));
			Если НайденныеСтроки.Количество() > 0 Тогда
				Форма.Элементы.Категории.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
			КонецЕсли;
		ИначеЕсли Форма.ТипФильтра  = "БизнесРегионы" Тогда
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаБизнесРегионы;
			Форма.Элементы.БизнесРегионы.ТекущаяСтрока = ТекущееЗначениеФильтраНастройки;
		ИначеЕсли Форма.ТипФильтра = "ГруппыДоступа" Тогда
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаГруппыДоступа;
			Форма.Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока = ТекущееЗначениеФильтраНастройки;
		ИначеЕсли Форма.ТипФильтра = "Менеджер" Тогда
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.СтраницаМенеджеры;
			Форма.Элементы.Менеджеры.ТекущаяСтрока = ТекущееЗначениеФильтраНастройки;
#Вставка
		ИначеЕсли Форма.ТипФильтра = "бг_ГруппыПартнеров" Тогда
			Форма.Элементы.СтраницыТипФильтра.ТекущаяСтраница = Форма.Элементы.бг_СтраницаГруппыПартнеров;
			бг_ЗаполнитьДеревоГруппПартнеров(Форма);
			Форма.Элементы.бг_ГруппыПартнеров.ТекущаяСтрока = НайтиСтрокуВДанныхФормыДерево(Форма.бг_ГруппыПартнеров, ТекущееЗначениеФильтраНастройки, "Значение", Истина);
#КонецВставки
		КонецЕсли;

		Если ИспользоватьФильтрНастройки <> Неопределено Тогда
			Настройки.Удалить("ИспользоватьФильтр");
			Если Форма.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаВыбораИспользуютсяТолькоПартнеры" И Форма.ПоПартнеру Тогда
				Форма.ИспользоватьФильтр = Ложь;
			Иначе
				Форма.ИспользоватьФильтр =  ИспользоватьФильтрНастройки;
			КонецЕсли;
		КонецЕсли;

		Если ТолькоЗначимыеНастройки <> Неопределено Тогда
			Форма.ТолькоЗначимые = ТолькоЗначимыеНастройки;
		КонецЕсли;

		Форма.НеОтрабатыватьАктивизациюПанелиНавигации = Истина;
		ИзменитьОтборСписок(Форма,Истина,Ложь);

	КонецЕсли;

	Настройки.Удалить("ТипФильтра");
	Если ТекущееЗначениеФильтраНастройки <> Неопределено Тогда
		Настройки.Удалить("ТекущееЗначениеФильтра");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&ИзменениеИКонтроль("ЗаполнитьСписокВыбораТипФильтраСписокПартнеров")
Процедура бг_ЗаполнитьСписокВыбораТипФильтраСписокПартнеров(Форма, СписокВыбора)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесРегионы") 
		И ПравоДоступа("Чтение", Метаданные.Справочники.БизнесРегионы) Тогда
		СписокВыбора.Добавить("БизнесРегионы", НСтр("ru = 'бизнес-региону';
													|en = 'business region'"));
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.Пользователи) Тогда
		СписокВыбора.Добавить("Менеджер", НСтр("ru = 'основному менеджеру';
												|en = 'employee in charge'"));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаПартнеров")
		И ПравоДоступа("Чтение", Метаданные.Справочники.ГруппыДоступаПартнеров) Тогда
		СписокВыбора.Добавить("ГруппыДоступа", НСтр("ru = 'группе доступа';
													|en = 'access group'"));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") Тогда
		ДополнитьСписокВыбораТипФильтраСписокПартнеров(Форма, СписокВыбора);
	КонецЕсли;
#Вставка
	СписокВыбора.Добавить(
		"бг_ГруппыПартнеров",
		НСтр("ru = 'группе партнера';
			|en = 'partner group'"));
#КонецВставки
	
КонецПроцедуры

Процедура бг_ЗаполнитьДеревоГруппПартнеров(Форма)
	
	Форма.бг_ГруппыПартнеров.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	битГруппыПартнеров.Ссылка КАК Значение,
	|	ПРЕДСТАВЛЕНИЕ(битГруппыПартнеров.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.битГруппыПартнеров КАК битГруппыПартнеров
	|
	|УПОРЯДОЧИТЬ ПО
	|	Значение
	|ИТОГИ ПО
	|	Значение ИЕРАРХИЯ";
	
	Результат = Запрос.Выполнить();
	
	Дерево = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Дерево.Строки.Сортировать("Значение");
	
	СтрокиПервыйУровень = Форма.бг_ГруппыПартнеров.ПолучитьЭлементы();
	
	Для Каждого Строка Из Дерево.Строки Цикл
		
		Строка.Строки.Сортировать("Значение");
		
		СтрокаГруппы = СтрокиПервыйУровень.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаГруппы, Строка);
		бг_ДобавитьСтрокиВДеревоНавигацииГруппПартнеров(Строка, СтрокаГруппы, Истина);
		
	КонецЦикла;
	
	Форма.ТекущееСвойствоПанелиНавигации = Форма.ТипФильтра;
	
КонецПроцедуры

Процедура бг_ДобавитьСтрокиВДеревоНавигацииГруппПартнеров(РодительскаяСтрока, СтрокаРодитель, ВыполнятьПроверку = Ложь)
	
	Для Каждого Строка Из РодительскаяСтрока.Строки Цикл
		
		Если Строка.Значение = РодительскаяСтрока.Значение Или Строка.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиДерева = СтрокаРодитель.ПолучитьЭлементы();
		НоваяСтрока = СтрокиДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		бг_ДобавитьСтрокиВДеревоНавигацииГруппПартнеров(Строка, НоваяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти